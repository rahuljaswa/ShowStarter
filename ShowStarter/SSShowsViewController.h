//
//  SSShowsViewController.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/23/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSShowsViewControllerDelegate <NSObject>

- (NSPredicate *)predicateForShowsFetch;

@end


@interface SSShowsViewController : UITableViewController

@property (nonatomic, weak) id<SSShowsViewControllerDelegate> delegate;

@end
