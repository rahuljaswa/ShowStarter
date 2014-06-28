//
//  SSAppDelegate.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/23/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "SSAppDelegate.h"
#import "SSAuthenticationManager.h"
#import "SSCoreDataManager.h"
#import "SSShowDataStore.h"
#import "SSTabBarController.h"
#import "User.h"
#import <SVProgressHUD/SVProgressHUD.h>


@interface SSAppDelegate () <SSAuthenticationManagerDelegate>

@property (nonatomic, strong, readonly) SSAuthenticationManager *authManager;
@property (nonatomic, strong, readonly) SSTabBarController *tabBarController;

@end


@implementation SSAppDelegate

@synthesize authManager = _authManager;
@synthesize tabBarController = _tabBarController;

#pragma mark - Custom getters and setters

- (SSAuthenticationManager *)authManager
{
    if (!_authManager) {
        _authManager = [[SSAuthenticationManager alloc] init];
        _authManager.delegate = self;
    }
    return _authManager;
}

- (SSTabBarController *)tabBarController
{
    if (!_tabBarController) {
        _tabBarController = [[SSTabBarController alloc] init];
    }
    return _tabBarController;
}

#pragma mark - Helpers

- (void)synchronizeDataWithPFCurrentUser:(PFUser *)pfCurrentUser
{
    if (!pfCurrentUser) {
        NSString *reason = @"pfCurrentUser cannot be nil";
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
    }
    
    if (pfCurrentUser) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Downloading shows", nil)
                             maskType:SVProgressHUDMaskTypeBlack];
        
        [[SSShowDataStore sharedInstance] downloadShowsWithCompletion:^(BOOL success) {
            if (success) {
                [User updateOrCreateUserWithPFUser:pfCurrentUser];
                [[SSCoreDataManager sharedInstance] saveContext];
                User *currentUser = [User currentUser];
                if (!currentUser) {
                    NSString *reason = @"We should always have a current user by the time we are synchronizing remote data";
                    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
                }
                
                if ([SVProgressHUD isVisible]) {
                    [SVProgressHUD dismiss];
                }
                
                [[SSShowDataStore sharedInstance] downloadAllEpisodesForUser:currentUser];
            } else {
                NSLog(@"Error downloading shows");
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Failed to download shows", nil)];
            }
        }];
    }
}

#pragma mark - SSAuthenticationManagerDelegate methods

- (void)authenticationManager:(SSAuthenticationManager *)authenticationManager
                 didLogInUser:(PFUser *)user
{
    self.window.rootViewController = self.tabBarController;
    [self synchronizeDataWithPFCurrentUser:user];
}

- (void)authenticationManager:(SSAuthenticationManager *)authenticationManager
                didSignUpUser:(PFUser *)user
{
    self.window.rootViewController = self.tabBarController;
    [self synchronizeDataWithPFCurrentUser:user];
}

#pragma mark - UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *parseAppID = @"GblbkvqPetuHaYD8pCJXXKnjIittxLwgjNFhGfwc";
    NSString *parseClientKey = @"ckr1m1go7nDRk6lxuUbudp1mYrwGQDfAbl9hK3Xn";
    [Parse setApplicationId:parseAppID clientKey:parseClientKey];
    [PFFacebookUtils initializeFacebook];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([self.authManager needsAuthentication]) {
        [self.authManager authenticateWithWindow:self.window];
    } else {
        [self synchronizeDataWithPFCurrentUser:[PFUser currentUser]];
        self.window.rootViewController = self.tabBarController;
    }

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[SSCoreDataManager sharedInstance] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (![self.authManager needsAuthentication]) {
        [self synchronizeDataWithPFCurrentUser:[PFUser currentUser]];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}

@end
