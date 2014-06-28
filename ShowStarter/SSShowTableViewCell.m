//
//  SSShowTableViewCell.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/23/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "SSShowDataSource.h"
#import "SSShowTableViewCell.h"
#import "UIImage+SSAdditions.h"
#import <SDWebImage/UIImageView+WebCache.h>

@import QuartzCore.QuartzCore;


@interface SSShowTableViewCell ()

@property (nonatomic, strong) SSShowDataSource *showDataSource;
@property (nonatomic, strong, readonly) UIImageView *banner;

@end


@implementation SSShowTableViewCell

@synthesize banner = _banner;
@synthesize following = _following;

#pragma mark - Custom getters and setters

- (UIImageView *)banner {
    if (!_banner) {
        _banner = [[UIImageView alloc] initWithFrame:CGRectZero];
        _banner.contentMode = UIViewContentModeScaleAspectFit;
        _banner.backgroundColor = [UIColor blackColor];
        
        UIView *f = self.following;
        f.translatesAutoresizingMaskIntoConstraints = NO;
        [_banner addSubview:f];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(f);
        
        [_banner addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[f]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
        [_banner addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[f]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
    }
    return _banner;
}

- (UILabel *)following {
    if (!_following) {
        _following = [[UILabel alloc] initWithFrame:CGRectZero];
        _following.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.9f];
        _following.text = NSLocalizedString(@"Following!", nil);
        _following.textAlignment = NSTextAlignmentCenter;
        _following.textColor = [UIColor whiteColor];
        _following.font = [UIFont fontWithName:@"Avenir" size:36.0f];
    }
    return _following;
}

#pragma mark - Helpers

+ (void)updateShowCell:(SSShowTableViewCell *)showCell withDataSource:(SSShowDataSource *)datasource
{
    showCell.title.text = [datasource.title uppercaseString];
    if (datasource.isFollowedByCurrentUser) {
        showCell.following.alpha = 1.0f;
    } else {
        showCell.following.alpha = 0.0f;
    }
    
    showCell.banner.image = [UIImage imageWithColor:[UIColor blackColor]];
    __weak SSShowTableViewCell *weakShowCell = showCell;
    [showCell.banner setImageWithURL:[NSURL URLWithString:datasource.imageBannerURL]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
    {
        [weakShowCell.banner.layer addAnimation:[CATransition animation] forKey:kCATransition];
    }];
}

#pragma mark - UITableViewCell overrides

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = self.banner;
    }
    return self;
}

#pragma mark - Public methods

- (void)updateWithShowDataSource:(SSShowDataSource *)showDataSource {
    if (!showDataSource) {
        NSString *reason = @"showDataSource cannot be nil";
        [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
    }
    
    self.showDataSource = showDataSource;
    [[self class] updateShowCell:self withDataSource:showDataSource];
}

@end
