//
//  SSEpisodesViewController.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/29/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "Episode.h"
#import "Show.h"
#import "User.h"

#import "NSDate+SSAdditions.h"
#import "SSCoreDataManager.h"
#import "SSEpisodeDataSource.h"
#import "SSEpisodeTableViewCell.h"
#import "SSEpisodesViewController.h"
#import "SSShowDataStore.h"

static NSString *const kSSEpisodesReuseID = @"SSEpisodesReuseID";


@interface SSEpisodesViewController ()

@property (nonatomic, strong) NSArray *episodesThisWeek;
@property (nonatomic, strong) NSArray *upcomingEpisodes;
@property (nonatomic, strong) NSArray *pastEpisodes;

@end


@implementation SSEpisodesViewController

#pragma mark - Helpers (setup)

- (void)loadEpisodes
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"show IN %@", [User currentUser].showsFollowed];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstAired" ascending:NO];
    NSArray *episodes = [[SSCoreDataManager sharedInstance] findAllOfEntityWithName:@"Episode"
                                                                          predicate:predicate
                                                                    sortDescriptors:@[sortDescriptor]];

    NSMutableArray *mutableEpisodes = [[NSMutableArray alloc] initWithArray:episodes];
    
    // episodes this week
    NSPredicate *episodesThisWeekPredicate = [NSPredicate predicateWithFormat:@"(firstAired > %@) AND (firstAired < %@)",
                                              [NSDate startOfCurrentWeekWithCalendar:[NSCalendar currentCalendar]],
                                               [NSDate endOfCurrentWeekWithCalendar:[NSCalendar currentCalendar]]];
    
    NSMutableArray *mutableEpisodesThisWeek = [[NSMutableArray alloc] init];
    NSArray *episodesThisWeek = [mutableEpisodes filteredArrayUsingPredicate:episodesThisWeekPredicate];
    for (Episode *episode in episodesThisWeek) {
        [mutableEpisodesThisWeek addObject:[SSEpisodeDataSource episodeDataSourceWithEpisode:episode]];
        [mutableEpisodes removeObject:episode];
    }
    self.episodesThisWeek = mutableEpisodesThisWeek;
    
    // upcoming episodes
    NSPredicate *upcomingEpisodesPredicate = [NSPredicate predicateWithFormat:@"firstAired > %@",
                                              [NSDate date]];
    
    NSArray *upcomingEpisodes = [mutableEpisodes filteredArrayUsingPredicate:upcomingEpisodesPredicate];
    NSMutableArray *mutableUpcomingEpisodes = [[NSMutableArray alloc] init];
    for (Episode *episode in upcomingEpisodes) {
        [mutableUpcomingEpisodes addObject:[SSEpisodeDataSource episodeDataSourceWithEpisode:episode]];
        [mutableEpisodes removeObject:episode];
    }
    self.upcomingEpisodes = mutableUpcomingEpisodes;
    
    // past episodes
    NSArray *pastEpisodes = [NSArray arrayWithArray:mutableEpisodes];
    NSMutableArray *mutablePastEpisodes = [[NSMutableArray alloc] init];
    for (Episode *episode in pastEpisodes) {
        [mutablePastEpisodes addObject:[SSEpisodeDataSource episodeDataSourceWithEpisode:episode]];
        [mutableEpisodes removeObject:episode];
    }
    self.pastEpisodes = mutablePastEpisodes;
    
    [self.tableView reloadData];
}

- (void)prepareTableView
{
    [self.tableView registerClass:[SSEpisodeTableViewCell class] forCellReuseIdentifier:kSSEpisodesReuseID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)addNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showsDownloadCompletedNotification:)
                                                 name:@"SSShowsDownloadCompleted"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(seasonDownloadCompletedNotification:)
                                                 name:@"SSSeasonDownloadCompleted"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userShowsFollowedDidChange:)
                                                 name:@"SSUserShowsFollowedDidChange"
                                               object:nil];
}

#pragma mark - Helpers (handlers)

- (void)showsDownloadCompletedNotification:(NSNotification *)notification
{
    [self loadEpisodes];
}

- (void)seasonDownloadCompletedNotification:(NSNotification *)notification
{
    [self loadEpisodes];
}

- (void)userShowsFollowedDidChange:(NSNotification *)notification
{
    [[SSShowDataStore sharedInstance] downloadAllEpisodesForUser:[User currentUser]];
    [self loadEpisodes];
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"New episodes this week", nil);
    } else if (section == 1) {
        return NSLocalizedString(@"Upcoming episodes", nil);
    } else if (section == 2) {
        return NSLocalizedString(@"Past episodes", nil);
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.episodesThisWeek count];
    } else if (section == 1) {
        return [self.upcomingEpisodes count];
    } else if (section == 2) {
        return [self.pastEpisodes count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSEpisodeDataSource *dataSource;
    if (indexPath.section == 0) {
        dataSource = [self.episodesThisWeek objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        dataSource = [self.upcomingEpisodes objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2) {
        dataSource = [self.pastEpisodes objectAtIndex:indexPath.row];
    }
    
    SSEpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSSEpisodesReuseID forIndexPath:indexPath];
    [cell updateWithEpisodeDataSource:dataSource];
    return cell;
}

#pragma mark - UITableViewController overrides

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareTableView];
    [self loadEpisodes];
    [self addNotificationObservers];
}

@end
