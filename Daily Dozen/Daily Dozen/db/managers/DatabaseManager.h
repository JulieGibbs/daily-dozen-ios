//
//  DatabaseManager.h
//  Daily Dozen
//
//  Created by Chan Kruse on 2015-10-02.
//  Copyright © 2015 NutritionFacts.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DatabaseManager : NSObject {
	NSPersistentStoreCoordinator *_dataCoordinator;
	NSPersistentStoreCoordinator *_userCoordinator;
	NSPersistentStore *_dataStore;
	NSPersistentStore *_userStore;
	NSManagedObjectContext *_dataContext;
	NSManagedObjectContext *_userContext;
	NSManagedObjectModel *_model;
	NSOperationQueue *_operationQueue;
}

+ (DatabaseManager *)sharedInstance;

// Managing local stores
- (BOOL)loadDataStore:(NSError *__autoreleasing *)error;
- (BOOL)resetDataStore:(NSError *__autoreleasing *)error;
- (BOOL)isDataStoreLoaded;
- (BOOL)isDatabaseUpdateRequiredForUserID:(NSNumber *)identifier error:(NSError *__autoreleasing *)error;
- (BOOL)loadStoreForUserID:(NSNumber *)identifier error:(NSError *__autoreleasing *)error;
- (BOOL)unloadCurrentUserStore:(NSError *__autoreleasing *)error;
- (BOOL)deleteStoreForUserID:(NSNumber *)identifier error:(NSError *__autoreleasing *)error;
- (BOOL)isUserStoreLoaded;

// Obtaining contexts
- (NSManagedObjectContext *)defaultDataContext;
- (NSManagedObjectContext *)temporaryDataContext;
- (NSManagedObjectContext *)defaultUserContext;
- (NSManagedObjectContext *)temporaryUserContext;

// Performing background changes
- (NSOperation *)performBackgroundDataChanges:(void (^)(NSManagedObjectContext *context))changeBlock completion:(void (^)(NSManagedObjectContext *context))completion;
- (NSOperation *)performBackgroundUserChanges:(void (^)(NSManagedObjectContext *context))changeBlock completion:(void (^)(NSManagedObjectContext *context))completion;
- (void)waitUntilBackgroundChangesAreFinished;
- (void)cancelBackgroundChanges;

@end
