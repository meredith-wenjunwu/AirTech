//
//  HomeViewController.h
//  AirTech
//
//  Created by WuWenjun on 4/15/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JQFMDB.h"
#import "Spirometry.h"
#import "Gas.h"
#import "Predicted.h"

@interface HomeViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *gas;
@property (weak, nonatomic) IBOutlet UILabel *fvc;
@property (weak, nonatomic) IBOutlet UILabel *fev1;
@property (weak, nonatomic) IBOutlet UILabel *fev1fvc;
@property (weak, nonatomic) IBOutlet UILabel *gasPredicted;
@property (weak, nonatomic) IBOutlet UILabel *fvcPredicted;
@property (weak, nonatomic) IBOutlet UILabel *fev1Predicted;
@property (weak, nonatomic) IBOutlet UILabel *fev1fvcPredicted;
@property (weak, nonatomic) IBOutlet UILabel *pef;
@property (weak, nonatomic) IBOutlet UILabel *pefPredicted;
- (IBAction)refresh:(id)sender;


@end
