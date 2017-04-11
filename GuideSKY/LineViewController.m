//
//  LineViewController.m
//  AirTech
//
//  Created by WuWenjun on 4/10/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import "LineViewController.h"


@implementation LineViewController 



- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];

}

//- (void)viewDidLoad {
//    self.titleLabel.text = @"Line Chart";
//    self.lineChart.backgroundColor = [UIColor whiteColor];
//    self.lineChart.yGridLinesColor = [UIColor grayColor];
//    [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
//        obj.pointLabelColor = [UIColor blackColor];
//    }];
//    
//    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
//    self.lineChart.showCoordinateAxis = YES;
//    self.lineChart.yLabelFormat = @"%1.1f";
//    self.lineChart.xLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:8.0];
//    [self.lineChart setXLabels:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6 Time (s)"]];
//    self.lineChart.yLabelColor = [UIColor blackColor];
//    self.lineChart.xLabelColor = [UIColor blackColor];
//    
//    // added an example to show how yGridLines can be enabled
//    // the color is set to clearColor so that the demo remains the same
//    self.lineChart.showGenYLabels = NO;
//    self.lineChart.showYGridLines = YES;
//    
//    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
//    //Only if you needed
//    self.lineChart.yFixedValueMax = 300.0;
//    self.lineChart.yFixedValueMin = 0.0;
//    
//    [self.lineChart setYLabels:@[
//                                 @"0 (L/s)",
//                                 @"2",
//                                 @"4",
//                                 @"6",
//                                 @"8",
//                                 @"10",
//                                 @"12",
//                                 ]
//     ];
//    
//    // Line Chart #1
//    NSArray *data01Array = @[@0, @280.2, @110, @50.0, @5, @0, @0];
//    //data01Array = [[data01Array reverseObjectEnumerator] allObjects];
//    PNLineChartData *data01 = [PNLineChartData new];
//    
//    data01.rangeColors = @[
//                           [[PNLineChartColorRange alloc] initWithRange:NSMakeRange(10, 30) color:[UIColor redColor]],
//                           [[PNLineChartColorRange alloc] initWithRange:NSMakeRange(100, 200) color:[UIColor purpleColor]]
//                           ];
//    data01.dataTitle = @"Alpha";
//    data01.color = PNFreshGreen;
//    data01.pointLabelColor = [UIColor blackColor];
//    data01.alpha = 0.3f;
//    data01.showPointLabel = YES;
//    data01.pointLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:9.0];
//    data01.itemCount = data01Array.count;
//    data01.inflexionPointColor = PNRed;
//    data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
//    data01.getData = ^(NSUInteger index) {
//        CGFloat yValue = [data01Array[index] floatValue];
//        return [PNLineChartDataItem dataItemWithY:yValue];
//    };
//
//    
//    self.lineChart.chartData = @[data01];
//    [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
//        obj.pointLabelColor = [UIColor blackColor];
//    }];
//    
//    _lineChart.showSmoothLines = YES;
//    [self.lineChart strokeChart];
//    
//    self.lineChart.delegate = self;
//    
//    
//    [self.view addSubview:self.lineChart];
//    
////    [self.view addSubview:legend];
//}

- (void)viewDidLoad {
    
}
@end
