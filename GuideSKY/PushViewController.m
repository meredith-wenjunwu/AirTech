//
//  PushViewController.m
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/10.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import "PushViewController.h"
#import "MianTabrViewController.h"
@interface PushViewController ()
{
    int selected;
    JQFMDB *db;
    int numDates;
    NSInteger param;
    NSArray *spiroArr;
    NSArray *gasArr;
    NSInteger spiroLength;
    NSInteger gasLength;
    
}
@end

@implementation PushViewController
@synthesize testType;
@synthesize spirometryParam;
@synthesize graphObjectIncrement;
@synthesize numOfObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    [graphObjectIncrement setValue:2];
    numDates = graphObjectIncrement.value;
    db = [JQFMDB shareDatabase:@"All"];
    //是否允许右划返回
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
    //number of object = 1
    [numOfObject setText:[NSString stringWithFormat:@"%i", numDates]];
    //spirometryParam
    param = [spirometryParam selectedSegmentIndex];
    gasArr = [db jq_lookupTable:@"gasTable" dicOrModel:[Gas class] whereFormat:nil];
    spiroArr = [db jq_lookupTable:@"spirometryTable" dicOrModel:[Spirometry class] whereFormat:nil];
    spiroLength = [spiroArr count];
    gasLength = [gasArr count];
    [self draw];
    
    if ([testType selectedSegmentIndex] == 0) {
        [self spirometryDatasets];
        [spirometryParam setHidden:NO];
        [spirometryParam setEnabled:YES];
    } else {
        [spirometryParam setHidden:YES];
        [spirometryParam setEnabled:NO];
        [self gasDatasets];
    }
}

-(void) refreshdata {
    gasArr = [db jq_lookupTable:@"gasTable" dicOrModel:[Gas class] whereFormat:nil];
    spiroArr = [db jq_lookupTable:@"spirometryTable" dicOrModel:[Spirometry class] whereFormat:nil];
    spiroLength = [spiroArr count];
    gasLength = [gasArr count];
    if ([testType selectedSegmentIndex] == 0) {
        [self spirometryDatasets];
    } else {
        [spirometryParam setHidden:YES];
        [spirometryParam setEnabled:NO];
        [self gasDatasets];
    }
    
}

-(void) draw {
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
    self.lineGraph.averageLine.dashPattern = @[@(1.5),@(1.5)];
    
    // Set the graph's animation style to draw, fade, or none
    self.lineGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.lineGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.lineGraph.formatStringForValues = @"%.1f";
    

}

-(void) spirometryDatasets {
    if (!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    else [self.arrayOfValues removeAllObjects];
    if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    else [self.arrayOfDates removeAllObjects];
    
    
//    Spirometry *last = [spiroArr lastObject];
//    double v = [self selectedTestValue:last];
    
    if ([spiroArr count] > 1) {
        for (int i = 0; i<numDates; i++) {
            Spirometry *slast = [spiroArr objectAtIndex:(spiroLength-i-1)];
            double v = [self selectedTestValue:slast];
            [self.arrayOfValues insertObject:@(v) atIndex:0];
            [self.arrayOfDates insertObject:slast.date atIndex:0];
        }
    } else {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Ooooops"
                                     message:@"No data or only 1 data available! Why not take some test?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}



-(void) gasDatasets {
    if (!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    else [self.arrayOfValues removeAllObjects];
    if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    else [self.arrayOfDates removeAllObjects];
    
//    Gas *last = [gasArr lastObject];
//    double v = last.max;
    
    if ([gasArr count] > 1) {
        for (int i = 0; i<numDates; i++) {
            Gas *glast = [gasArr objectAtIndex:(gasLength-i-1)];
            double v = glast.max;
            [self.arrayOfValues insertObject:@(v) atIndex:0];
            [self.arrayOfDates insertObject:glast.date atIndex:0];
        }
    } else {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Ooooops"
                                     message:@"No data or only 1 data available! Why not take some test?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //显示tabbar
    [MianTabrViewController HiddenTabbar:false];
    [self refreshdata];
    [self draw];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //隐藏tabbar
    [MianTabrViewController HiddenTabbar:true];
}


- (IBAction)changedTestType:(id)sender {
    if ([testType selectedSegmentIndex] == 0) {
        [graphObjectIncrement setValue:2];
        [spirometryParam setHidden:NO];
        [spirometryParam setEnabled:YES];
        numDates = graphObjectIncrement.value;
        [self spirometryDatasets];
        [self.lineGraph reloadGraph];
    } else {
        [graphObjectIncrement setValue:2];
        numDates = graphObjectIncrement.value;
        [spirometryParam setHidden:YES];
        [spirometryParam setEnabled:NO];
        [self gasDatasets];
        [self.lineGraph reloadGraph];
    }
    
    
}
- (IBAction)spiroParamChanged:(id)sender {
    param = [spirometryParam selectedSegmentIndex];
    [self spirometryDatasets];
    [self.lineGraph reloadGraph];
}

- (IBAction)addOrRemovePointFromGraph:(id)sender {
    if (graphObjectIncrement.value < 2) {
        [graphObjectIncrement setValue:2];
        return;
    }
    if ([testType selectedSegmentIndex] == 0) {
        if (graphObjectIncrement.value > spiroLength) {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Ooooops"
                                         message:@"No more data to display"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    } else {
        if (graphObjectIncrement.value > gasLength) {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"Ooooops"
                                         message:@"No more data to display"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    }
    if (graphObjectIncrement.value > numDates) {
        // Add point
        if ([testType selectedSegmentIndex] == 0) {
            Spirometry *slast = [spiroArr objectAtIndex:(spiroLength-graphObjectIncrement.value)];
            double v = [self selectedTestValue:slast];
            [self.arrayOfValues insertObject:@(v) atIndex:0];
            [self.arrayOfDates insertObject:slast.date atIndex:0];
            numDates++;
        } else {
            Gas *glast = [gasArr objectAtIndex:(gasLength-graphObjectIncrement.value-1)];
            double v = glast.max;
            [self.arrayOfValues insertObject:@(v) atIndex:0];
            [self.arrayOfDates insertObject:glast.date atIndex:0];
            numDates++;
        }
        [self.lineGraph reloadGraph];
        
    } else if (self.graphObjectIncrement.value < numDates) {
        // Remove point
        [self.arrayOfValues removeObjectAtIndex:0];
        [self.arrayOfDates removeObjectAtIndex:0];
        numDates--;
        [self.lineGraph reloadGraph];
    }
    [numOfObject setText:[NSString stringWithFormat:@"%i", numDates]];
}


- (IBAction)refreshData:(id)sender {
    [self refreshdata];
    [self.lineGraph reloadGraph];

    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Updated"
                                 message:@"Data has been successfully updated!"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)clearData:(id)sender {
    [db jq_deleteAllDataFromTable:@"spirometryTable"];
    [db jq_deleteAllDataFromTable:@"gasTable"];
    [self refreshdata];
    [self.lineGraph reloadGraph];
    
}

- (double)selectedTestValue: (Spirometry*) s {
    double r;
    switch ([spirometryParam selectedSegmentIndex]) {
        case 0:
            return s.FVC;
        case 1:
            return s.FEV1;
        case 2:
            r = (s.FEV1/s.FVC);
            return r;
        case 3:
            return s.PEF;
    }
    return -1;
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
    return 1;
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
    switch ([testType selectedSegmentIndex]) {
        case 0:
            return @" L";
        case 1:
            return @" L";
        case 2:
            return @"";
        case 3:
            return @"L/min";
    }
    return @"";
}



- (NSString *)labelForDateAtIndex:(NSInteger)index {
    
    return [_arrayOfDates objectAtIndex:index];
}



@end
