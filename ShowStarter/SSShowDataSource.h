//
//  SSShowDataSource.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/23/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Show;

@interface SSShowDataSource : NSObject

@property (nonatomic, assign, getter = isFollowedByCurrentUser, readonly) BOOL followedByCurrentUser;
@property (nonatomic, copy, readonly) NSString *imageBannerURL;
@property (nonatomic, strong, readonly) NSManagedObjectID *showID;
@property (nonatomic, copy, readonly) NSString *title;

+ (instancetype)showsDataSourceWithShow:(Show *)show;

@end
