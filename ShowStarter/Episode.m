//
//  Episode.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/29/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "Episode.h"
#import "SSCoreDataManager.h"


@implementation Episode

@dynamic episode;
@dynamic firstAired;
@dynamic number;
@dynamic overview;
@dynamic screen;
@dynamic season;
@dynamic show;
@dynamic title;
@dynamic traktStatsHated;
@dynamic traktStatsLoved;
@dynamic traktStatsPercentage;
@dynamic traktStatsVotes;
@dynamic tvdbID;

#pragma mark - Public methods

- (NSString *)firstAiredDisplayString
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE, MMM d, yyyy  h:mm aaa"];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    });
    return [formatter stringFromDate:self.firstAired];
}

+ (Episode *)updateOrCreateEpisodeWithJSONResponseObject:(NSDictionary *)jsonResponseObject
{
    Episode *episode = nil;
    NSNumber *tvdbID = jsonResponseObject[@"tvdb_id"];
    if (tvdbID && [tvdbID isKindOfClass:[NSNumber class]]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tvdbID == %@", tvdbID];
        NSArray *matchingEpisodes = [[SSCoreDataManager sharedInstance] findAllOfEntityWithName:@"Episode"
                                                                                      predicate:predicate
                                                                                sortDescriptors:nil];
        
        NSUInteger matchingEpisodesCount = [matchingEpisodes count];
        if (matchingEpisodesCount > 0) {
            if (matchingEpisodesCount == 1) {
                episode = [matchingEpisodes lastObject];
            } else {
                NSLog(@"There are multiple episodes associated with this ID:\n%@", jsonResponseObject);
            }
        } else {
            episode = (Episode *)[[SSCoreDataManager sharedInstance] createNewEntityWithName:@"Episode"];
        }
        
        episode.tvdbID = [tvdbID stringValue];
        
        NSNumber *episodeNumber = jsonResponseObject[@"episode"];
        if ([episodeNumber isKindOfClass:[NSNumber class]]) {
            episode.episode = episodeNumber;
        }
        
        NSNumber *firstAired = jsonResponseObject[@"first_aired_utc"];
        if ([firstAired isKindOfClass:[NSNumber class]]) {
            episode.firstAired = [NSDate dateWithTimeIntervalSince1970:[firstAired integerValue]];
        }
        
        NSNumber *number = jsonResponseObject[@"number"];
        if ([number isKindOfClass:[NSNumber class]]) {
            episode.number = number;
        }
        
        NSNumber *season = jsonResponseObject[@"season"];
        if ([season isKindOfClass:[NSNumber class]]) {
            episode.season = season;
        }
        
        NSString *overview = jsonResponseObject[@"overview"];
        if ([overview isKindOfClass:[NSString class]]) {
            episode.overview = overview;
        }
        
        NSString *title = jsonResponseObject[@"title"];
        if ([title isKindOfClass:[NSString class]]) {
            episode.title = title;
        }
        
        NSNumber *traktStatsHated = jsonResponseObject[@"ratings"][@"hated"];
        if ([traktStatsHated isKindOfClass:[NSNumber class]]) {
            episode.traktStatsHated = traktStatsHated;
        }
        
        NSNumber *traktStatsLoved = jsonResponseObject[@"ratings"][@"loved"];
        if ([traktStatsLoved isKindOfClass:[NSNumber class]]) {
            episode.traktStatsLoved = traktStatsLoved;
        }
        
        NSNumber *traktStatsPercentage = jsonResponseObject[@"ratings"][@"percentage"];
        if ([traktStatsPercentage isKindOfClass:[NSNumber class]]) {
            episode.traktStatsPercentage = traktStatsPercentage;
        }
        
        NSNumber *traktStatsVotes = jsonResponseObject[@"ratings"][@"votes"];
        if ([traktStatsVotes isKindOfClass:[NSNumber class]]) {
            episode.traktStatsVotes = traktStatsVotes;
        }
    } else {
        NSLog(@"JSON response object lacks tvdbID:\n%@", jsonResponseObject);
    }
    return episode;
}

@end
