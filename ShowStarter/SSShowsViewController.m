//
//  SSShowsViewController.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/23/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "Show.h"
#import "User.h"

#import "SSCoreDataManager.h"
#import "SSParseAPIClient.h"
#import "SSShowDataSource.h"
#import "SSShowsViewController.h"
#import "SSShowTableViewCell.h"

static NSString *const kSSShowsReuseID = @"SSShowsReuseID";


@interface SSShowsViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong, readonly) UISearchBar *searchBar;
@property (nonatomic, strong, readonly) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSArray *filteredShows;
@property (nonatomic, strong) NSArray *shows;

@end


@implementation SSShowsViewController

@synthesize searchController = _searchController;

#pragma mark - Custom getters and setters

- (UISearchDisplayController *)searchController {
    if (!_searchController) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.delegate = self;
        _searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar
                                                              contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsDataSource = self;
        _searchController.searchResultsDelegate = self;
        _searchController.displaysSearchBarInNavigationBar = YES;
    }
    return _searchController;
}

#pragma mark - Helpers (setup)

- (void)loadShows
{
    NSPredicate *predicate = nil;
    if ([self.delegate respondsToSelector:@selector(predicateForShowsFetch)]) {
        predicate = [self.delegate predicateForShowsFetch];
    }

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"traktStatsVotes" ascending:NO];
    NSArray *shows = [[SSCoreDataManager sharedInstance] findAllOfEntityWithName:@"Show"
                                                                       predicate:predicate
                                                                 sortDescriptors:@[sortDescriptor]];
    NSMutableArray *showDataSources = [[NSMutableArray alloc] init];
    for (Show *show in shows) {
        [showDataSources addObject:[SSShowDataSource showsDataSourceWithShow:show]];
    }
    self.shows = showDataSources;
    
    [self.tableView reloadData];
    if (self.searchController.isActive) {
        [self.searchController.searchResultsTableView reloadData];
    }
}

- (void)prepareTableView
{
    [self.searchController.searchResultsTableView registerClass:[SSShowTableViewCell class]
                                                forCellReuseIdentifier:kSSShowsReuseID];
    [self.tableView registerClass:[SSShowTableViewCell class] forCellReuseIdentifier:kSSShowsReuseID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)addNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showsDownloadCompletedNotification:)
                                                 name:@"SSShowsDownloadCompleted"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userShowsFollowedDidChange:)
                                                 name:@"SSUserShowsFollowedDidChange"
                                               object:nil];
}

#pragma mark - Helpers (handlers)

- (void)showsDownloadCompletedNotification:(NSNotification *)notification
{
    [self loadShows];
}

- (void)userShowsFollowedDidChange:(NSNotification *)notification
{
    [self loadShows];
}

#pragma mark - UISearchDisplayDelegate methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.searchController setActive:YES animated:YES];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    NSMutableArray *mutableFilteredShows = [[NSMutableArray alloc] init];
    for (SSShowDataSource *dataSource in self.shows) {
        NSStringCompareOptions options = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange range = [dataSource.title rangeOfString:searchString options:options];
        if (range.location != NSNotFound) {
            [mutableFilteredShows addObject:dataSource];
        }
    }
    self.filteredShows = mutableFilteredShows;
    return YES;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSShowDataSource *dataSource;
    if (tableView == self.searchController.searchResultsTableView) {
        dataSource = [self.filteredShows objectAtIndex:indexPath.row];
    } else {
        dataSource = [self.shows objectAtIndex:indexPath.row];
    }
    
    NSManagedObjectContext *context = [[SSCoreDataManager sharedInstance] managedObjectContext];
    
    NSError *error;
    Show *show = (Show *)[context existingObjectWithID:dataSource.showID error:&error];
    if (error) {
        NSLog(@"Error finding existing object with ID:\n%@", dataSource.showID);
    }
    if (show) {
        User *user = [User currentUser];
        if ([show.usersFollowing containsObject:user]) {
            [user removeShowsFollowedObject:show];
        } else {
            [user addShowsFollowedObject:show];
        }
        [[SSCoreDataManager sharedInstance] saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SSUserShowsFollowedDidChange"
                                                            object:self];
        
        [[SSParseAPIClient sharedInstance] synchronizeCurrentUser:user withCompletion:nil];
    } else {
        NSLog(@"Error retrieving show:\n%@", dataSource);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59.0f;
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchController.searchResultsTableView) {
        return [self.filteredShows count];
    } else {
        return [self.shows count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSShowDataSource *dataSource;
    if (tableView == self.searchController.searchResultsTableView) {
        dataSource = [self.filteredShows objectAtIndex:indexPath.row];
    } else {
        dataSource = [self.shows objectAtIndex:indexPath.row];
    }
    
    SSShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSSShowsReuseID forIndexPath:indexPath];
    [cell updateWithShowDataSource:dataSource];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewController overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareTableView];
    [self loadShows];
    [self addNotificationObservers];
}

@end
