//
//  Global.m
//  AirTech
//
//  Created by WuWenjun on 4/17/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@implementation Global
+(NSMutableArray*)array {
    static NSMutableArray *statArray;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statArray = [NSMutableArray array];
    });
    return statArray;
}
@end
