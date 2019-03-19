//
//  LocalDataManager.m
//  TestCoreData
//
//  Created by lgc on 2019/2/20.
//  Copyright © 2019 lgc. All rights reserved.
//

#import "LocalDataManager.h"
#import "objc/runtime.h"

@implementation LocalDataManager

// MARK: 懒加载部分属性
// 创建唯一实例
+ (instancetype)shareInstance {
    static LocalDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LocalDataManager alloc] init];
    });
    return instance;
}

- (NSManagedObjectModel *)Mom {
    
    NSURL *momUrl = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension:@"momd"];
    _Mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momUrl];
    
    return _Mom;
}

- (NSPersistentStoreCoordinator *)Psc {
    if (!_Psc) {
        _Psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.Mom];
        //数据库的名称和路径
        NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *sqlPath = [docStr stringByAppendingPathComponent:@"coreData.sqlite"];
        NSLog(@"数据库 path = %@", sqlPath);
        NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
        NSError *error = nil;
        [_Psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
        if (error) {
            NSLog(@"添加数据库失败:%@",error);
        }else {
            NSLog(@"添加数据库成功");
        }
    }
    return _Psc;
}

- (NSManagedObjectContext *)Moc {
    if (!_Moc) {
        _Moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_Moc setPersistentStoreCoordinator:self.Psc];
    }
    return _Moc;
}

#pragma mark - 获取搜索请求
- (NSFetchRequest *)fetchRequest:(NSString *)entityName predicate:(NSString *)predicateString {
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:_Moc]];
    if (predicateString != nil && ![predicateString isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        [request setPredicate:predicate];
    }
    return request;
}

#pragma mark - allAttributes
- (NSMutableArray *)ClassAttributes:(id)classModel
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *className = NSStringFromClass([classModel class]);
    const char *cClassName = [className UTF8String];
    
    id classM = objc_getClass(cClassName);
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(classM, &outCount);

    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *attributeName = [NSString stringWithUTF8String:property_getName(property)];
        [array addObject:attributeName];
    }
    return array;
}

#pragma mark - 增 删 改 查
- (BOOL)insertModel:(id)model{
    NSManagedObject *mo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([model class]) inManagedObjectContext:_Moc];
    for (NSString *propertyName in [self ClassAttributes:model]) {
        [mo setValue:[model valueForKey:propertyName] forKey:propertyName];
    }
    BOOL result = [self saveContext];
    if (result) {
        NSLog(@"插入数据成功：%@",model);
    }else {
        NSLog(@"插入数据(%@)失败",NSStringFromClass([model class]));
    }
    return result;
}

- (BOOL)removeModel:(id)model predicate:(NSString *)predicateString {
    NSError *error = nil;
    NSArray *list = [_Moc executeFetchRequest:[self fetchRequest:NSStringFromClass([model class]) predicate:predicateString] error:&error];
    if (list.count > 0 ) {
        for (NSManagedObject *manager in list) {
            [_Moc deleteObject:manager];
        }
    }else {
        NSLog(@"查询结果为空，不可删除");
    }
    return [self saveContext];
}

- (BOOL)changeModel:(id)model predicate:(NSString *)predicateString
{
    NSError *error = nil;
    NSArray *listArray = [_Moc executeFetchRequest:[self fetchRequest:NSStringFromClass([model class]) predicate:predicateString] error:&error];
    
    if (listArray.count > 0) {
        for (NSManagedObject *manager in listArray) {
            for (NSString *propertyName in [self ClassAttributes:model]) {
                [manager setValue:[model valueForKey:propertyName] forKey:propertyName];
            }
            NSLog(@"修改成功__%@", manager);
        }
    }else {
        NSLog(@"查询结果为空，无法修改");
    }
    return [self saveContext];
}

- (NSMutableArray *)requestModel:(id)model predicate:(NSString *)predicateString {
    NSError *error = nil;
    NSArray *list = [_Moc executeFetchRequest:[self fetchRequest:NSStringFromClass([model class]) predicate:predicateString] error:&error];
    NSMutableArray *resultArr = [[NSMutableArray alloc] initWithArray:list];
    return resultArr;
}

- (BOOL)saveContext {
    NSManagedObjectContext *moc = self.Moc;
    if (!moc) {
        return false;
    }
    NSError *error = nil;
    if ([moc hasChanges]) {
        [moc save:&error];
        if (error) {
            NSLog(@"保存到数据库失败:%@",error);
            return false;
        }
    }
    return true;
}
@end
