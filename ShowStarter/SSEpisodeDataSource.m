//
//  SSEpisodeDataSource.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/29/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "Episode.h"
#import "Show.h"

#import "SSEpisodeDataSource.h"


@interface SSEpisodeDataSource ()

@property (nonatomic, strong, readwrite) NSString *airDate;
@property (nonatomic, strong, readwrite) NSString *episode;
@property (nonatomic, strong, readwrite) NSManagedObjectID *episodeID;
@property (nonatomic, strong, readwrite) NSString *episodeTitle;
@property (nonatomic, strong, readwrite) NSString *season;
@property (nonatomic, strong, readwrite) NSString *showTitle;
@property (nonatomic, strong, readwrite) NSString *overview;

@end


@implementation SSEpisodeDataSource

+ (instancetype)episodeDataSourceWithEpisode:(Episode *)episode
{
    SSEpisodeDataSource *dataSource = [[self alloc] init];
    dataSource.airDate = [episode firstAiredDisplayString];
    dataSource.episode = [episode.episode stringValue];
    dataSource.episodeID = episode.objectID;
    dataSource.episodeTitle = episode.title;
    dataSource.season = [episode.season stringValue];
    dataSource.showTitle = episode.show.title;
    dataSource.overview = episode.overview;
    return dataSource;
}

@end
