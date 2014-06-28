//
//  SSParseAPIClient.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/24/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "SSParseAPIClient.h"
#import "Show.h"
#import "User.h"
#import <Parse/Parse.h>


@implementation SSParseAPIClient

#pragma mark - Public methods

+ (instancetype)sharedInstance
{
    static SSParseAPIClient *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SSParseAPIClient alloc] init];
    });
    return manager;
}

- (void)synchronizeCurrentUser:(User *)currentUser withCompletion:(PFBooleanResultBlock)block
{
    if (!currentUser) {
        NSString *reason = @"Current user cannot be nil";
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
    }
    
    PFUser *currentPFUser = [PFUser currentUser];
    if (!currentPFUser) {
        NSString *reason = @"There should always be a current PF user at this point";
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
    }
    
    NSMutableArray *showsFollowedTVBDIDs = [[NSMutableArray alloc] init];
    for (Show *show in currentUser.showsFollowed) {
        [showsFollowedTVBDIDs addObject:show.tvdbID];
    }
    currentPFUser[@"showsFollowed"] = showsFollowedTVBDIDs;
    [currentPFUser saveInBackgroundWithBlock:block];
}

@end
