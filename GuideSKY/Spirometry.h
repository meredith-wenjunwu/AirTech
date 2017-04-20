//
//  Spirometry.h
//  AirTech
//
//  Created by WuWenjun on 4/14/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Spirometry : NSObject

@property (nonatomic, strong)NSMutableArray *values;
@property (nonatomic, strong)NSMutableArray *times;
@property (nonatomic, strong)NSString *date;
@property (nonatomic, assign)double FEV1;
@property (nonatomic, assign)double FVC;
@property (nonatomic, assign)double PEF;
@property (nonatomic, strong)Spirometry *spiro;


@end

