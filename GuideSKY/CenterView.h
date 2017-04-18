//
//  CenterView.h
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/10.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Global.h"

@interface CenterView : UIView
@property (nonatomic, assign) id delegate;
@property BLE *bleShield;
@property (weak, nonatomic) IBOutlet UILabel *blowMessage;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property NSMutableArray *tableData;

@property (weak, nonatomic) IBOutlet UIButton *gasAnalysis;
@property (weak, nonatomic) IBOutlet UIButton *spirometry;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
