//
//  SSEpisodeTableViewCell.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/29/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SSEpisodeDataSource;

@interface SSEpisodeTableViewCell : UITableViewCell

- (void)updateWithEpisodeDataSource:(SSEpisodeDataSource *)episodeDataSource;

@end
