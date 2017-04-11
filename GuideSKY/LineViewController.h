//
//  LineViewController.h
//  AirTech
//
//  Created by WuWenjun on 4/10/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AAChartView.h"
#import "PNChart.h"
#import "BEMSimpleLineGraphView.h"



@interface LineViewController : UIViewController <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *lineGraph;

//@property (nonatomic) PNLineChart * lineChart;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


//@property(nonatomic,strong)AAChartModel *chartModel;
//@property(nonatomic,strong)AAChartView *chartView;
@end
