//
//  User.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/29/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "Show.h"
#import "SSCoreDataManager.h"
#import "User.h"


@implementation User

@dynamic currentUser;
@dynamic email;
@dynamic parseObjectId;
@dynamic username;
@dynamic showsFollowed;

#pragma mark Helpers

+ (User *)userWithParseObjectId:(NSString *)parseObjectId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parseObjectId == %@", parseObjectId];
    NSArray *fetchResults = [[SSCoreDataManager sharedInstance] findAllOfEntityWithName:@"User"
                                                                               predicate:predicate
                                                                         sortDescriptors:nil];
    User *user = nil;
    NSUInteger matchingUsersCount = [fetchResults count];
    if (matchingUsersCount > 0) {
        if (matchingUsersCount == 1) {
            user = [fetchResults lastObject];
        } else {
            NSLog(@"There are multiple matching users for Parse object ID:\n%@", parseObjectId);
        }
    }
    return user;
}

#pragma mark Public methods

+ (User *)updateOrCreateUserWithPFUser:(PFUser *)pfUser
{
    User *user = nil;
    NSString *parseObjectId = pfUser.objectId;
    if (parseObjectId && [parseObjectId isKindOfClass:[NSString class]]) {
        user = [self userWithParseObjectId:parseObjectId];
        if (!user) {
            user = (User *)[[SSCoreDataManager sharedInstance] createNewEntityWithName:@"User"];
        }
        
        user.parseObjectId = parseObjectId;
        user.currentUser = @([pfUser.objectId isEqualToString:[PFUser currentUser].objectId]);
        user.email = pfUser.email;
        user.username = pfUser.username;
        
        for (NSString *tvdbID in pfUser[@"showsFollowed"]) {
            Show *show = [Show showWithTVDBID:tvdbID];
            if (show && ![user.showsFollowed containsObject:show]) {
                [user addShowsFollowedObject:show];
            }
        }
    } else {
        NSLog(@"PF user lacks objectId:\n%@", pfUser);
    }
    return user;
}

+ (User *)currentUser
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentUser == %@", @YES];
    NSArray *fetchResults = [[SSCoreDataManager sharedInstance] findAllOfEntityWithName:@"User"
                                                                              predicate:predicate
                                                                        sortDescriptors:nil];
    User *user = nil;
    NSUInteger matchingUsersCount = [fetchResults count];
    if (matchingUsersCount > 0) {
        if (matchingUsersCount == 1) {
            user = [fetchResults lastObject];
        } else {
            NSLog(@"There are multiple users set as the current user");
        }
    }
    return user;
}

@end
