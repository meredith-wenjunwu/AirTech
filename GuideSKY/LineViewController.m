//
//  LineViewController.m
//  AirTech
//
//  Created by WuWenjun on 4/10/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import "LineViewController.h"

@interface LineViewController () {
    int totalNumber;
} @end

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
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _lineGraph.delegate = self;
    _lineGraph.dataSource = self;
    [self hydrateDatasets];
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    // Apply the gradient to the bottom portion of the graph
    self.lineGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    // Enable and disable various graph properties and axis displays
    self.lineGraph.enableTouchReport = YES;
    self.lineGraph.enablePopUpReport = YES;
    self.lineGraph.enableYAxisLabel = YES;
    self.lineGraph.autoScaleYAxis = YES;
    self.lineGraph.alwaysDisplayDots = NO;
    self.lineGraph.enableReferenceXAxisLines = YES;
    self.lineGraph.enableReferenceYAxisLines = YES;
    self.lineGraph.enableReferenceAxisFrame = YES;

    // Draw an average line
    self.lineGraph.averageLine.enableAverageLine = YES;
    self.lineGraph.averageLine.alpha = 0.6;
    self.lineGraph.averageLine.color = [UIColor darkGrayColor];
    self.lineGraph.averageLine.width = 2.5;
    self.lineGraph.averageLine.dashPattern = @[@(2),@(2)];
    
    //Set the graph's animation style to draw, fade, or none
    self.lineGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.lineGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.lineGraph.formatStringForValues = @"%.1f";
    
    self.lineGraph.enableBezierCurve = YES;
    // The labels to report the values of the graph when the user touches it

}

#pragma mark - generate data

- (void)hydrateDatasets {
    // Reset the arrays of values (Y-Axis points) and dates (X-Axis points / labels)
    if (!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];
    
    totalNumber = 0;
    NSDate *baseDate = [NSDate date];
    BOOL showNullValue = true;
    
    // Add objects to the array based on the stepper value
    for (int i = 0; i < 9; i++) {
        [self.arrayOfValues addObject:@([self getRandomFloat])]; // Random values for the graph
        if (i == 0) {
            [self.arrayOfDates addObject:baseDate]; // Dates for the X-Axis of the graph
        } else if (showNullValue && i == 4) {
            [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[i-1]]]; // Dates for the X-Axis of the graph
            self.arrayOfValues[i] = @(BEMNullGraphValue);
        } else {
            [self.arrayOfDates addObject:[self dateForGraphAfterDate:self.arrayOfDates[i-1]]]; // Dates for the X-Axis of the graph
        }
        
        totalNumber = totalNumber + [[self.arrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
}

#pragma mark - SimpleLineGraph Data Source
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 2;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    
    NSString *label = [self labelForDateAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

//- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
//    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.arrayOfValues objectAtIndex:index]];
//}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.labelValues.alpha = 0.0;
    } completion:^(BOOL finished) {
//        self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.lineGraph calculatePointValueSum] intValue]];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            self.labelValues.alpha = 1.0;
        } completion:nil];
    }];
}


/* - (void)lineGraphDidFinishDrawing:(BEMSimpleLineGraphView *)graph {
 // Use this method for tasks after the graph has finished drawing
 } */

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    return @" (L/s)";
}


- (float)getRandomFloat {
    float i1 = (float)(arc4random() % 1000000) / 100 ;
    return i1;
}
- (NSString *)labelForDateAtIndex:(NSInteger)index {
    NSDate *date = self.arrayOfDates[index];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd";
    NSString *label = [df stringFromDate:date];
    return label;
}

- (NSDate *)dateForGraphAfterDate:(NSDate *)date {
    NSTimeInterval secondsInTwentyFourHours = 24 * 60 * 60;
    NSDate *newDate = [date dateByAddingTimeInterval:secondsInTwentyFourHours];
    return newDate;
}

@end
