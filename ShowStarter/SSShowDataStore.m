//
//  SSShowDataStore.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/28/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "Episode.h"
#import "Show.h"
#import "User.h"

#import "SSCoreDataManager.h"
#import "SSShowDataStore.h"
#import "SSTraktAPIClient.h"


@implementation SSShowDataStore

#pragma mark - Helpers

- (void)userShowsFollowedDidChange:(NSNotification *)notification
{
    [self downloadAllEpisodesForUser:[User currentUser]];
}

#pragma mark - NSObject overrides

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userShowsFollowedDidChange:)
                                                     name:@"SSUserShowsFollowedDidChange"
                                                   object:nil];
    }
    return self;
}

#pragma mark - Public methods

+ (instancetype)sharedInstance
{
    static SSShowDataStore *dataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataStore = [[SSShowDataStore alloc] init];
    });
    return dataStore;
}

- (void)downloadShowsWithCompletion:(void (^)(BOOL))completion
{
    SSTraktAPIClient *client = [SSTraktAPIClient sharedInstance];
    [client getTrendingShowsSuccess:^(NSURLSessionDataTask *task, id responseObject)
    {
        for (NSDictionary *showsResponseObject in responseObject) {
            Show *show = [Show updateOrCreateShowWithJSONResponseObject:showsResponseObject];
            if (!show) {
                NSLog(@"Error updating or creating show with JSON response object:\n%@", showsResponseObject);
            }
        }
        [[SSCoreDataManager sharedInstance] saveContext];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SSShowsDownloadCompleted"
                                                            object:self];
        
        if (completion) {
            completion(YES);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error retrieving shows:\n%@", [error localizedDescription]);
        if (completion) {
            completion(NO);
        }
    }];
}

- (void)downloadAllEpisodesForUser:(User *)user
{
    NSSet *followedShows = user.showsFollowed;
    for (Show *show in followedShows) {
        NSString *tvdbID = show.tvdbID;
        SSTraktAPIClient *client = [SSTraktAPIClient sharedInstance];
        [client getSeasonsForShowTVDBID:tvdbID
                                success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSArray *seasons = responseObject;
             for (NSDictionary *season in seasons) {
                 __block NSNumber *seasonNumber = season[@"season"];
                 [client getSeasonForShowTVDBID:tvdbID
                                   seasonNumber:seasonNumber
                                        success:^(NSURLSessionDataTask *task, id responseObject)
                  {
                      for (NSDictionary *episodeResponseObject in responseObject) {
                          Episode *episode = [Episode updateOrCreateEpisodeWithJSONResponseObject:episodeResponseObject];
                          episode.show = [Show showWithTVDBID:tvdbID];
                          if (!episode) {
                              NSLog(@"Error updating or creating episode with JSON response object:\n%@", episodeResponseObject);
                          }
                      }
                      [[SSCoreDataManager sharedInstance] saveContext];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"SSSeasonDownloadCompletedNotification"
                                                                          object:self];
                  }
                                        failure:^(NSURLSessionDataTask *task, NSError *error)
                  {
                      NSLog(@"Error retrieving season:\n%@",
                            [error localizedDescription]);
                  }];
             }
         }
                                failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             NSLog(@"Error retrieving seasons:\n%@", [error localizedDescription]);
         }];
    }
}

@end
