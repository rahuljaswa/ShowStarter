//
//  SSShowDataStore.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/28/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import <Foundation/Foundation.h>


@class User;

@interface SSShowDataStore : NSObject

+ (instancetype)sharedInstance;

- (void)downloadShowsWithCompletion:(void(^)(BOOL success))completion;
- (void)downloadAllEpisodesForUser:(User *)user;

@end
