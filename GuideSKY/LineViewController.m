//
//  LineViewController.m
//  AirTech
//
//  Created by WuWenjun on 4/10/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import "LineViewController.h"
#import "MianTabrViewController.h"


@interface LineViewController () {
    int totalNumber;
    AppDelegate *appdelegate;
    JQFMDB *db;
    int hz;
} @end

@implementation LineViewController
@synthesize isSpirometry;
@synthesize tableData;

- (IBAction)back:(id)sender {
    [self.arrayOfValues removeAllObjects];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isSpirometry = [[NSUserDefaults standardUserDefaults] boolForKey:@"Spiro"];
    //isSpirometry = YES;
    // Do any additional setup after loading the view, typically from a nib.
    _lineGraph.delegate = self;
    _lineGraph.dataSource = self;
    db = [JQFMDB shareDatabase:@"All"];
    if (isSpirometry) {
        // frequency of pressure sensor
        hz = 10;
    } else {
        hz = 5;
        [self.pefText setHidden:YES];
        [self.pefTitle setHidden:YES];
        [self.fvcText setHidden:YES];
        [self.fvcTitle setHidden:YES];
        [self.fev1Text setHidden:YES];
        [self.fev1Title setHidden:YES];
        [self.fevfvcText setHidden:YES];
        [self.fevfvcTitle setHidden:YES];
    }
    if (![db jq_isExistTable:@"spirometryTable"]) {
        NSLog(@"No Spirometry Table!");
    }
    
    if (isSpirometry) {
        [self spirometryDatasets];
    } else {
        [self gasDatasets];
    }
    
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


#pragma mark - generate data for spirometry

- (void)spirometryDatasets {

    // Reset the arrays of values (Y-Axis points) and dates (X-Axis points / labels)
//    if (!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
//    if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
//    [self.arrayOfDates removeAllObjects];
    
    //    totalNumber = 0;
    //    NSDate *baseDate = [NSDate date];
    //    BOOL showNullValue = true;
    // Add objects to the array based on the stepper value
    
//    
//    float a[61], b[61], c[61];
//    
//    float max = -1;
//    for (int i = 0; i < 61; i++) {
//        float f = [self.arrayOfValues[i] floatValue];
//        a[i] = f;
//        b[i] = 0.1;
//        if (f > max) {
//            max = f;
//        }
//        
//        [self.arrayOfDates addObject:@(i*0.1)];
//        
//    }
//    //trapzoidal integral
//    vDSP_vtrapz(a, 1, b, c, 1, 61);
//    
//    //need to comment out later
//    //[db jq_deleteAllDataFromTable:@"spirometryTable"];
//    
//    double PEF = (double) max;
//    
//    NSDate *now = [NSDate date];
//    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
//    NSInteger seconds = [tz secondsFromGMTForDate: now];
//    NSDate *new = [NSDate dateWithTimeInterval: seconds sinceDate: now];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateFormat = @"yyyy/MM/dd";
//    NSString *dateS = [df stringFromDate:new];
    
    NSArray *spiroArr = [db jq_lookupTable:@"spirometryTable" dicOrModel:[Spirometry class] whereFormat:nil];
    Spirometry *spirometry = [spiroArr lastObject];
    self.arrayOfValues = spirometry.values;
    self.arrayOfDates = spirometry.times;
    [self.fvcText setText:[NSString stringWithFormat:@"%0.2f", spirometry.FVC]];
    [self.fev1Text setText:[NSString stringWithFormat:@"%0.2f", spirometry.FEV1]];
    [self.fevfvcText setText:[NSString stringWithFormat:@"%0.2f", (spirometry.FVC/spirometry.FEV1)]];
    [self.pefText setText:[NSString stringWithFormat:@"%0.2f", spirometry.PEF]];
    
//    [db jq_insertTable:@"spirometryTable" dicOrModel:spirometry];
//    NSArray *spiroArr = [db jq_lookupTable:@"spirometryTable" dicOrModel:[Spirometry class] whereFormat:nil];
//    Spirometry *last = [spiroArr lastObject];
    
}

#pragma mark - generate data for gas analysis
- (void)gasDatasets {
    self.arrayOfValues = [Global array];
    if (!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.arrayOfDates removeAllObjects];
    
    float max = -1;
    for (int i = 0; i < 31; i++) {
        float f = [self.arrayOfValues[i] floatValue];
        if (f > max) {
            max = f;
        }
        
        [self.arrayOfDates addObject:@(i*0.5)];
    }
    
    //need to comment out later
    //[db jq_deleteAllDataFromTable:@"spirometryTable"];
    
    double PEF = (double) max;
    
    NSDate *now = [NSDate date];
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: now];
    NSDate *new = [NSDate dateWithTimeInterval: seconds sinceDate: now];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy/MM/dd";
    NSString *dateS = [df stringFromDate:new];
    
    
#pragma initiate Spirometry result and store it in database
    Gas *gas = [[Gas alloc]init];
    gas.values = [[NSMutableArray alloc] initWithArray:self.arrayOfValues copyItems:YES];
    gas.date = dateS;
    gas.max = PEF;
    
    
    [_fvcTitle setText:@"Carbon Dioxide (%)"];
    [_fvcText setText:[NSString stringWithFormat:@"%0.2f %%", PEF]];
    [_fvcTitle setHidden:NO];
    [_fvcText setHidden:NO];

    
    [db jq_insertTable:@"gasTable" dicOrModel:gas];
    
//    NSArray *gasArr = [db jq_lookupTable:@"gasTable" dicOrModel:[Gas class] whereFormat:nil];
//    NSLog(@"表中所有数据:%@", gasArr);
    //[db jq_deleteAllDataFromTable:(NSString *)@"gasTable"];
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
    if (isSpirometry)
        return 10;
    else
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



- (NSString *)labelForDateAtIndex:(NSInteger)index {
    int time = [self.arrayOfDates[index] intValue];
    NSString *label = [NSString stringWithFormat:@"%i", time];
    return label;
}



@end
