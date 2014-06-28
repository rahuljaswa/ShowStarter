//
//  Show.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/28/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Show : NSManagedObject

@property (nonatomic, retain) NSString * airday;
@property (nonatomic, retain) NSString * airtime;
@property (nonatomic, retain) NSSet *episodes;
@property (nonatomic, retain) NSString * genres;
@property (nonatomic, retain) NSString * imageBannerURL;
@property (nonatomic, retain) NSString * imageFanArtURL;
@property (nonatomic, retain) NSString * imagePosterURL;
@property (nonatomic, retain) NSString * network;
@property (nonatomic, retain) NSString * overview;
@property (nonatomic, retain) NSNumber * runtime;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * traktStatsHated;
@property (nonatomic, retain) NSNumber * traktStatsLoved;
@property (nonatomic, retain) NSNumber * traktStatsPercentage;
@property (nonatomic, retain) NSNumber * traktStatsVotes;
@property (nonatomic, retain) NSString * tvdbID;
@property (nonatomic, retain) NSSet *usersFollowing;
@property (nonatomic, retain) NSNumber * year;

@end


@interface Show ()

+ (Show *)updateOrCreateShowWithJSONResponseObject:(NSDictionary *)jsonResponseObject;
+ (Show *)showWithTVDBID:(NSString *)tvdbID;

@end


@interface Show (CoreDataGeneratedAccessors)

- (void)addEpisodesObject:(NSManagedObject *)value;
- (void)removeEpisodesObject:(NSManagedObject *)value;
- (void)addEpisodes:(NSSet *)values;
- (void)removeEpisodes:(NSSet *)values;

- (void)addUsersFollowingObject:(NSManagedObject *)value;
- (void)removeUsersFollowingObject:(NSManagedObject *)value;
- (void)addUsersFollowing:(NSSet *)values;
- (void)removeUsersFollowing:(NSSet *)values;

@end
