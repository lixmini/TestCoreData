//
//  User+CoreDataProperties.h
//  TestCoreData
//
//  Created by lgc on 2019/2/20.
//  Copyright © 2019 lgc. All rights reserved.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSDate *birthday;
@property (nullable, nonatomic, retain) NSData *customPicture;
@property (nonatomic) int16_t grade;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t phoneNum;
@property (nullable, nonatomic, copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END
