//
//  SSCoreDataManager.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/24/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SSCoreDataManager : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedInstance;
+ (NSManagedObjectModel *)sharedModel;

- (NSManagedObject *)createNewEntityWithName:(NSString *)name;

- (NSArray *)findAllOfEntityWithName:(NSString *)name;
- (NSArray *)findAllOfEntityWithName:(NSString *)name
                           predicate:(NSPredicate *)predicate
                     sortDescriptors:(NSArray *)sortDescriptor;

- (void)saveContext;

@end
