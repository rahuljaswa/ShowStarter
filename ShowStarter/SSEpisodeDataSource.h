//
//  SSEpisodeDataSource.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/29/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Episode;

@interface SSEpisodeDataSource : NSObject

@property (nonatomic, strong, readonly) NSString *airDate;
@property (nonatomic, strong, readonly) NSString *episode;
@property (nonatomic, strong, readonly) NSManagedObjectID *episodeID;
@property (nonatomic, strong, readonly) NSString *episodeTitle;
@property (nonatomic, strong, readonly) NSString *season;
@property (nonatomic, strong, readonly) NSString *showTitle;
@property (nonatomic, strong, readonly) NSString *overview;

+ (instancetype)episodeDataSourceWithEpisode:(Episode *)episode;

@end
