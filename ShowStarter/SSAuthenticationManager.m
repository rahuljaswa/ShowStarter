//
//  SSAuthenticationManager.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/29/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "SSAuthenticationManager.h"
#import <Parse/Parse.h>


@interface SSAuthenticationManager () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, strong, readonly) PFLogInViewController *logInVC;

@end


@implementation SSAuthenticationManager

@synthesize logInVC = _logInVC;

#pragma mark - Custom getters and setters

- (PFLogInViewController *)logInVC
{
    if (!_logInVC) {
        _logInVC = [[PFLogInViewController alloc] init];
        
        NSUInteger fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsPasswordForgotten | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton;
        
        _logInVC.fields = fields;
        _logInVC.delegate = self;
        _logInVC.signUpController.delegate = self;
    }
    return _logInVC;
}

#pragma mark - PFLogInViewControllerDelegate methods

- (void)logInViewController:(PFLogInViewController *)logInController
    didFailToLogInWithError:(NSError *)error
{
    
}

- (void)logInViewController:(PFLogInViewController *)logInController
               didLogInUser:(PFUser *)user
{
    if ([self.delegate respondsToSelector:@selector(authenticationManager:didLogInUser:)]) {
        [self.delegate authenticationManager:self didLogInUser:user];
    }
}

#pragma mark - PFSignUpViewControllerDelegate methods

- (void)signUpViewController:(PFSignUpViewController *)signUpController
    didFailToSignUpWithError:(NSError *)error
{

}

- (void)signUpViewController:(PFSignUpViewController *)signUpController
               didSignUpUser:(PFUser *)user
{
    if ([self.delegate respondsToSelector:@selector(authenticationManager:didSignUpUser:)]) {
        [self.delegate authenticationManager:self didSignUpUser:user];
    }
}

#pragma mark - Public methods

- (void)authenticateWithWindow:(UIWindow *)window
{
    window.rootViewController = self.logInVC;
}

- (BOOL)needsAuthentication
{
    return ![PFUser currentUser];
}

@end
