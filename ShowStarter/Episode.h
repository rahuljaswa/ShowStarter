//
//  Episode.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/29/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import <CoreData/CoreData.h>


@class Show;

@interface Episode : NSManagedObject

@property (nonatomic, retain) NSNumber *episode;
@property (nonatomic, retain) NSDate *firstAired;
@property (nonatomic, retain) NSNumber *number;
@property (nonatomic, retain) NSString *overview;
@property (nonatomic, retain) NSString *screen;
@property (nonatomic, retain) NSNumber *season;
@property (nonatomic, retain) Show *show;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *traktStatsHated;
@property (nonatomic, retain) NSNumber *traktStatsLoved;
@property (nonatomic, retain) NSNumber *traktStatsPercentage;
@property (nonatomic, retain) NSNumber *traktStatsVotes;
@property (nonatomic, retain) NSString *tvdbID;

- (NSString *)firstAiredDisplayString;

+ (Episode *)updateOrCreateEpisodeWithJSONResponseObject:(NSDictionary *)jsonResponseObject;

@end
