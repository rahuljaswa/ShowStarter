//
//  SSShowTableViewCell.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/23/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SSShowDataSource;

@interface SSShowTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *following;
@property (nonatomic, strong, readonly) UILabel *title;

- (void)updateWithShowDataSource:(SSShowDataSource *)showDataSource;

@end
