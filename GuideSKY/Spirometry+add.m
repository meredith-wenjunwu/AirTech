//
//  Spirometry+add.m
//  AirTech
//
//  Created by WuWenjun on 4/13/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import "Spirometry+add.h"
#import "AppDelegate.h"

@implementation Spirometry (add)
+ (Spirometry *)addValuestoDatabase: (NSMutableArray *)values dateValue: (NSDate *)datevalue fvcValue: (double)fvcvalue fev1Value:(double)fev1value
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    Spirometry *spiro = nil;
    
    spiro = [NSEntityDescription insertNewObjectForEntityForName:@"Spirometry" inManagedObjectContext:context];
    
    //Create a New Object
    spiro.value = values;
    spiro.date =datevalue;
    spiro.fvc = fvcvalue;
    spiro.fev1 = fev1value;
    return spiro;
}

@end
