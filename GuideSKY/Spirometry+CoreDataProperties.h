//
//  Spirometry+CoreDataProperties.h
//  AirTech
//
//  Created by WuWenjun on 4/12/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Spirometry+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Spirometry (CoreDataProperties)

+ (NSFetchRequest<Spirometry *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, retain) NSObject *value;
@property (nonatomic) double fvc;
@property (nonatomic) double fev1;

@end

NS_ASSUME_NONNULL_END
