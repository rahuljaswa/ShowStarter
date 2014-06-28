//
//  SSParseAPIClient.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/24/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@class User;

@interface SSParseAPIClient : NSObject

+ (instancetype)sharedInstance;
- (void)synchronizeCurrentUser:(User *)currentUser withCompletion:(PFBooleanResultBlock)block;

@end
