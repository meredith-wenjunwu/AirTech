//
//  Predicted.h
//  AirTech
//
//  Created by WuWenjun on 4/14/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Predicted : NSObject

@property (nonatomic, assign)double fvc;
@property (nonatomic, assign)double fev1;
@property (nonatomic, assign)double pef;
@property (nonatomic, assign)double fevfvc;

@property (nonatomic, strong)Predicted *predic;
@end

