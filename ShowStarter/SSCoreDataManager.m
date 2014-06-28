//
//  SSCoreDataManager.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/24/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "SSCoreDataManager.h"


@implementation SSCoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - Custom getters and setters

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ShowStarter" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ShowStarter.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                              configuration:nil
                                                        URL:storeURL
                                                    options:@{
                                                              NSMigratePersistentStoresAutomaticallyOption: @YES,
                                                              NSInferMappingModelAutomaticallyOption: @YES
                                                              }
                                                      error:&error];
    return _persistentStoreCoordinator;
}

#pragma mark - Public singleton methods

+ (instancetype)sharedInstance {
    static SSCoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SSCoreDataManager alloc] init];
    });
    return manager;
}

+ (NSManagedObjectModel *)sharedModel {
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ShowStarter" withExtension:@"xcdatamodeld"]];
}

#pragma mark - Public create methods

- (NSManagedObject *)createNewEntityWithName:(NSString *)name {;
    return [NSEntityDescription insertNewObjectForEntityForName:name
                                         inManagedObjectContext:self.managedObjectContext];
}

#pragma mark - Public find methods

- (NSArray *)findAllOfEntityWithName:(NSString *)name {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:name];
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
}

- (NSArray *)findAllOfEntityWithName:(NSString *)name
                           predicate:(NSPredicate *)predicate
                     sortDescriptors:(NSArray *)sortDescriptors
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:name];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = sortDescriptors;
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];
}

#pragma mark - Public save methods

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
