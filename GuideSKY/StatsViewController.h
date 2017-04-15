//
//  StatsViewController.h
//  AirTech
//
//  Created by WuWenjun on 4/15/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *standardDeviationLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *medianLabel;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
@property (weak, nonatomic) IBOutlet UILabel *minimumLabel;
@property (weak, nonatomic) IBOutlet UILabel *maximumLabel;

@property (weak, nonatomic) IBOutlet UILabel *normalRange;
@property (weak, nonatomic) IBOutlet UILabel *rangeUnit;

@end
