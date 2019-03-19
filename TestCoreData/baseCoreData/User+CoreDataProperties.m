//
//  User+CoreDataProperties.m
//  TestCoreData
//
//  Created by lgc on 2019/2/20.
//  Copyright © 2019 lgc. All rights reserved.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"User"];
}

@dynamic age;
@dynamic birthday;
@dynamic customPicture;
@dynamic grade;
@dynamic name;
@dynamic phoneNum;
@dynamic userId;

@end
