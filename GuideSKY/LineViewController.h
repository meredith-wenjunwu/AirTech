//
//  LineViewController.h
//  AirTech
//
//  Created by WuWenjun on 4/10/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"
#import "Spirometry.h"
#import "JQFMDB.h"



@interface LineViewController : UIViewController <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *lineGraph;


@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;

@property JQFMDB *db;
//@property (nonatomic) PNLineChart * lineChart;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


//@property(nonatomic,strong)AAChartModel *chartModel;
//@property(nonatomic,strong)AAChartView *chartView;
@end
