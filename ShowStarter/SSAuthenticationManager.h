//
//  SSAuthenticationManager.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/29/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SSAuthenticationManager;
@class PFUser;

@protocol SSAuthenticationManagerDelegate <NSObject>

- (void)authenticationManager:(SSAuthenticationManager *)authenticationManager
                 didLogInUser:(PFUser *)user;
- (void)authenticationManager:(SSAuthenticationManager *)authenticationManager
                didSignUpUser:(PFUser *)user;

@end


@interface SSAuthenticationManager : NSObject

@property (nonatomic, weak) id<SSAuthenticationManagerDelegate> delegate;

- (void)authenticateWithWindow:(UIWindow *)window;
- (BOOL)needsAuthentication;

@end
