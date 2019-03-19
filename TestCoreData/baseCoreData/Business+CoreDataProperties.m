//
//  Business+CoreDataProperties.m
//  TestCoreData
//
//  Created by lgc on 2019/2/20.
//  Copyright © 2019 lgc. All rights reserved.
//
//

#import "Business+CoreDataProperties.h"

@implementation Business (CoreDataProperties)

+ (NSFetchRequest<Business *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Business"];
}

@dynamic businessGroup;
@dynamic businessGroupId;
@dynamic businessId;
@dynamic businessName;
@dynamic businessPic;
@dynamic businessType;

@end
