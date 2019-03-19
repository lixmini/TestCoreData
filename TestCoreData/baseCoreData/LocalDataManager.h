//
//  LocalDataManager.h
//  TestCoreData
//
//  Created by lgc on 2019/2/20.
//  Copyright © 2019 lgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define LocalDataManagerInstance [LocalDataManager shareInstance]

NS_ASSUME_NONNULL_BEGIN

@interface LocalDataManager : NSObject
@property (nonatomic,strong) NSManagedObjectContext *Moc;
@property (nonatomic,strong) NSManagedObjectModel *Mom;
@property (nonatomic,strong) NSPersistentStoreCoordinator *Psc;

+ (instancetype)shareInstance;

- (BOOL)saveContext;

- (NSFetchRequest *)fetchRequest:(NSString *)entityName predicate:(NSString *)predicateString;

- (BOOL)insertModel:(id)model;
- (BOOL)removeModel:(id)model predicate:(NSString *)predicateString;
- (BOOL)changeModel:(id)model predicate:(NSString *)predicateString;
- (NSMutableArray *)requestModel:(id)model predicate:(NSString *)predicateString;

@end

NS_ASSUME_NONNULL_END
