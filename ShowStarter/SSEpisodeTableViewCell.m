//
//  SSEpisodeTableViewCell.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/29/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "SSEpisodeDataSource.h"
#import "SSEpisodeTableViewCell.h"


@interface SSEpisodeTableViewCell ()

@property (nonatomic, strong) SSEpisodeDataSource *episodeDataSource;

@end


@implementation SSEpisodeTableViewCell


#pragma mark - UITableViewCell overrides

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}

#pragma mark - Public methods

- (void)updateWithEpisodeDataSource:(SSEpisodeDataSource *)episodeDataSource
{
    self.episodeDataSource = episodeDataSource;
    
    self.textLabel.text = episodeDataSource.showTitle;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@\nSeason %@, Episode %@\n%@",
                                 episodeDataSource.episodeTitle,
                                 episodeDataSource.airDate,
                                 episodeDataSource.season,
                                 episodeDataSource.season,
                                 episodeDataSource.overview];
    self.detailTextLabel.numberOfLines = 3;
    self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

@end
