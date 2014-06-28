//
//  SSShowDataSource.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/23/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "Show.h"
#import "User.h"

#import "SSShowDataSource.h"


@interface SSShowDataSource ()

@property (nonatomic, assign, getter = isFollowedByCurrentUser, readwrite) BOOL followedByCurrentUser;
@property (nonatomic, copy, readwrite) NSString *imageBannerURL;
@property (nonatomic, strong, readwrite) NSManagedObjectID *showID;
@property (nonatomic, copy, readwrite) NSString *title;

@end


@implementation SSShowDataSource

+ (instancetype)showsDataSourceWithShow:(Show *)show
{
    SSShowDataSource *dataSource = [[self alloc] init];
    dataSource.showID = show.objectID;
    dataSource.imageBannerURL = show.imageBannerURL;
    dataSource.title = show.title;
    dataSource.followedByCurrentUser = [[User currentUser].showsFollowed containsObject:show];
    return dataSource;
}

@end
