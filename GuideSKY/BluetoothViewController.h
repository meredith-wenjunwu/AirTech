//
//  UIViewController+Bluetooth.h
//  AirTech
//
//  Created by WuWenjun on 4/14/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"
#include "AppDelegate.h"
#include "Global.h"


@interface BluetoothViewController: UIViewController <BLEDelegate>
    
@property BLE *bleShield;
@property NSMutableArray *tableData;
    
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *btnConnect;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;

@end
