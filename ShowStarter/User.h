//
//  User.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/29/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Parse/Parse.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * currentUser;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * parseObjectId;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *showsFollowed;

+ (User *)updateOrCreateUserWithPFUser:(PFUser *)pfUser;
+ (User *)currentUser;

@end


@interface User (CoreDataGeneratedAccessors)

- (void)addShowsFollowedObject:(NSManagedObject *)value;
- (void)removeShowsFollowedObject:(NSManagedObject *)value;
- (void)addShowsFollowed:(NSSet *)values;
- (void)removeShowsFollowed:(NSSet *)values;

@end
