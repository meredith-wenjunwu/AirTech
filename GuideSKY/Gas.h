//
//  Gas.h
//  AirTech
//
//  Created by WuWenjun on 4/14/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gas : NSObject

@property (nonatomic, strong)NSMutableArray *values;
@property (nonatomic, strong)NSString *date;
@property (nonatomic, strong)Gas *gas;
@property (nonatomic, assign)double max;



@end

