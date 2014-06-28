//
//  SSTabBarController.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/24/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "User.h"

#import "SSEpisodesViewController.h"
#import "SSShowsViewController.h"
#import "SSTabBarController.h"


@interface SSTabBarController ()

@end


@implementation SSTabBarController

#pragma mark - UITabBarController helpers

- (UIViewController *)viewController:(UIViewController *)viewController
                           withTitle:(NSString *)title
                               image:(UIImage *)image
                       selectedImage:(UIImage *)selectedImage
{
    UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    viewController.tabBarItem = tabItem;
    return viewController;
}

#pragma mark - UITabBarController overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // explore tab
    SSShowsViewController *exploreVC = [[SSShowsViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *exploreVCNav = [[UINavigationController alloc] initWithRootViewController:exploreVC];

    // episodes tab
    UIViewController *episodesVC = [[SSEpisodesViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *episodesVCNav = [[UINavigationController alloc] initWithRootViewController:episodesVC];
    
    self.viewControllers = @[
                             [self viewController:exploreVCNav withTitle:@"Explore" image:nil selectedImage:nil],
                             [self viewController:episodesVCNav withTitle:@"Episodes" image:nil selectedImage:nil]
                             ];
}

@end
