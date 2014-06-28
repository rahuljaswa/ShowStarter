//
//  Show.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/28/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "Show.h"
#import "SSCoreDataManager.h"


@implementation Show

@dynamic airday;
@dynamic airtime;
@dynamic episodes;
@dynamic genres;
@dynamic imageBannerURL;
@dynamic imageFanArtURL;
@dynamic imagePosterURL;
@dynamic network;
@dynamic overview;
@dynamic runtime;
@dynamic title;
@dynamic traktStatsHated;
@dynamic traktStatsLoved;
@dynamic traktStatsPercentage;
@dynamic traktStatsVotes;
@dynamic tvdbID;
@dynamic usersFollowing;
@dynamic year;

+ (Show *)updateOrCreateShowWithJSONResponseObject:(NSDictionary *)jsonResponseObject
{
    Show *show = nil;
    NSString *tvdbID = jsonResponseObject[@"tvdb_id"];
    if (tvdbID && [tvdbID isKindOfClass:[NSString class]]) {
        show = [self showWithTVDBID:tvdbID];
        if (!show) {
            show = (Show *)[[SSCoreDataManager sharedInstance] createNewEntityWithName:@"Show"];
        }
        
        show.tvdbID = tvdbID;
        
        NSString *airday = jsonResponseObject[@"airday"];
        if ([airday isKindOfClass:[NSString class]]) {
            show.airday = airday;
        }
        
        NSArray *genres = jsonResponseObject[@"genres"];
        if ([genres isKindOfClass:[NSArray class]]) {
            show.airtime = [genres componentsJoinedByString:@","];
        }
        
        NSString *imageBannerURL = jsonResponseObject[@"images"][@"banner"];
        if ([imageBannerURL isKindOfClass:[NSString class]]) {
            show.imageBannerURL = imageBannerURL;
        }
        
        NSString *imageFanArtURL = jsonResponseObject[@"images"][@"fanart"];
        if ([imageFanArtURL isKindOfClass:[NSString class]]) {
            show.imageFanArtURL = imageFanArtURL;
        }
        
        NSString *imagePosterURL = jsonResponseObject[@"images"][@"poster"];
        if ([imagePosterURL isKindOfClass:[NSString class]]) {
            show.imagePosterURL = imagePosterURL;
        }
        
        NSString *network = jsonResponseObject[@"network"];
        if ([network isKindOfClass:[NSString class]]) {
            show.network = network;
        }
        
        NSString *overview = jsonResponseObject[@"overview"];
        if ([overview isKindOfClass:[NSString class]]) {
            show.overview = overview;
        }
        
        NSNumber *runtime = jsonResponseObject[@"runtime"];
        if ([runtime isKindOfClass:[NSNumber class]]) {
            show.runtime = runtime;
        }
        
        NSString *title = jsonResponseObject[@"title"];
        if ([title isKindOfClass:[NSString class]]) {
            show.title = title;
        }
        
        NSNumber *traktStatsHated = jsonResponseObject[@"ratings"][@"hated"];
        if ([traktStatsHated isKindOfClass:[NSNumber class]]) {
            show.traktStatsHated = traktStatsHated;
        }
        
        NSNumber *traktStatsLoved = jsonResponseObject[@"ratings"][@"loved"];
        if ([traktStatsLoved isKindOfClass:[NSNumber class]]) {
            show.traktStatsLoved = traktStatsLoved;
        }
        
        NSNumber *traktStatsPercentage = jsonResponseObject[@"ratings"][@"percentage"];
        if ([traktStatsPercentage isKindOfClass:[NSNumber class]]) {
            show.traktStatsPercentage = traktStatsPercentage;
        }
        
        NSNumber *traktStatsVotes = jsonResponseObject[@"ratings"][@"votes"];
        if ([traktStatsVotes isKindOfClass:[NSNumber class]]) {
            show.traktStatsVotes = traktStatsVotes;
        }
        
        NSNumber *year = jsonResponseObject[@"year"];
        if ([year isKindOfClass:[NSNumber class]]) {
            show.year = jsonResponseObject[@"year"];
        }
    } else {
        NSLog(@"JSON response object lacks tvdbID:\n%@", jsonResponseObject);
    }
    return show;
}

+ (Show *)showWithTVDBID:(NSString *)tvdbID {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tvdbID == %@", tvdbID];
    NSArray *matchingShows = [[SSCoreDataManager sharedInstance] findAllOfEntityWithName:@"Show"
                                                                               predicate:predicate
                                                                         sortDescriptors:nil];
    Show *show = nil;
    NSUInteger matchingShowsCount = [matchingShows count];
    if (matchingShowsCount > 0) {
        if (matchingShowsCount == 1) {
            show = [matchingShows lastObject];
        } else {
            NSLog(@"There are multiple shows associated with this ID:\n%@", tvdbID);
        }
    }
    return show;
}

@end
