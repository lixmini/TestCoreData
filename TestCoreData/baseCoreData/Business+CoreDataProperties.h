//
//  Business+CoreDataProperties.h
//  TestCoreData
//
//  Created by lgc on 2019/2/20.
//  Copyright © 2019 lgc. All rights reserved.
//
//

#import "Business+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Business (CoreDataProperties)

+ (NSFetchRequest<Business *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *businessGroup;
@property (nonatomic) int64_t businessGroupId;
@property (nonatomic) int32_t businessId;
@property (nullable, nonatomic, copy) NSString *businessName;
@property (nullable, nonatomic, retain) NSData *businessPic;
@property (nullable, nonatomic, copy) NSDecimalNumber *businessType;

@end

NS_ASSUME_NONNULL_END
