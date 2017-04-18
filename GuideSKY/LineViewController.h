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
#import "Gas.h"
#import "JQFMDB.h"
#import "BLE.h"
#include "AppDelegate.h"
#include <Accelerate/Accelerate.h>
#import "Global.h"



@interface LineViewController : UIViewController <BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource, BLEDelegate>
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *lineGraph;

@property BLE *bleShield;
@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;
@property (weak, nonatomic) IBOutlet UITextField *fvcText;
@property (weak, nonatomic) IBOutlet UITextField *fev1Text;
@property (weak, nonatomic) IBOutlet UITextField *fevfvcText;
@property (weak, nonatomic) IBOutlet UITextField *pefText;
@property (weak, nonatomic) IBOutlet UILabel *pefTitle;
@property (weak, nonatomic) IBOutlet UILabel *fvcTitle;
@property (weak, nonatomic) IBOutlet UILabel *fev1Title;
@property (weak, nonatomic) IBOutlet UILabel *fevfvcTitle;

@property NSMutableArray *tableData;
@property BOOL isSpirometry;

//@property (nonatomic) PNLineChart * lineChart;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


//@property(nonatomic,strong)AAChartModel *chartModel;
//@property(nonatomic,strong)AAChartView *chartView;
@end
