//
//  Spirometry+CoreDataProperties.m
//  AirTech
//
//  Created by WuWenjun on 4/12/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Spirometry+CoreDataProperties.h"

@implementation Spirometry (CoreDataProperties)

+ (NSFetchRequest<Spirometry *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Spirometry"];
}

@dynamic date;
@dynamic value;
@dynamic fvc;
@dynamic fev1;

@end
