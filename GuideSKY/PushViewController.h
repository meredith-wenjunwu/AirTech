//
//  PushViewController.h
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/10.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"
#import "Spirometry.h"
#import "Gas.h"
#import "JQFMDB.h"

@interface PushViewController : UIViewController <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *testType;
- (IBAction)changedTestType:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *spirometryParam;
@property (weak, nonatomic) IBOutlet UIStepper *graphObjectIncrement;
@property (weak, nonatomic) IBOutlet UITextField *numOfObject;

@end
