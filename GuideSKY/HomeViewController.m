//
//  StatsViewController.m
//  AirTech
//
//  Created by WuWenjun on 4/15/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property JQFMDB *db;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    [self loadData];
}
-(IBAction)refresh:(id)sender {
    [self loadData];
}



- (void)loadData {
    _db = [JQFMDB shareDatabase:@"All"];
    NSArray *userValue = [_db jq_lookupTable:@"predictedValue" dicOrModel:[Predicted class] whereFormat:nil];
    if ([userValue count] == 0) {
        NSLog(@"No user data saved in database!");
        return;
    }
    Predicted *p = userValue[0];
    double fvcStandard = p.fvc;
    double fev1Standard = p.fev1;
    double pefStandard = p.pef;
    double fevfvcStandard = p.fevfvc;
    
    NSArray *spiroArr = [_db jq_lookupTable:@"spirometryTable" dicOrModel:[Spirometry class] whereFormat:nil];
    NSArray *gasArr = [_db jq_lookupTable:@"gasTable" dicOrModel:[Gas class] whereFormat:nil];
    if ([spiroArr count] > 0) {
        Spirometry *slast = [spiroArr lastObject];
        
        [_fvc setText:[NSString stringWithFormat:@"%f",slast.FVC]];
        [_fev1 setText:[NSString stringWithFormat:@"%f",slast.FEV1]];
        double fevfvc = slast.FEV1/slast.FVC;
        [_fev1fvc setText:[NSString stringWithFormat:@"%f",fevfvc]];
        [_pef setText:[NSString stringWithFormat:@"%f", slast.PEF]];
        
        [_fev1Predicted setText:[NSString stringWithFormat: @"%0.2f %%", (100* slast.FEV1/fev1Standard)]];
        [_fvcPredicted setText:[NSString stringWithFormat:@"%0.2f %%", (100* slast.FVC/fvcStandard)]];
        [_fev1fvcPredicted setText:[NSString stringWithFormat:@"%0.2f %%", (100*fevfvc/fevfvcStandard)]];
        [_pefPredicted setText:[NSString stringWithFormat:@"%0.2f %%", (100*slast.PEF/pefStandard)]];
        
        
    }
    if ([gasArr count] > 0) {
        Gas *glast = [gasArr lastObject];
        [_gas setText:[NSString stringWithFormat:@"%0.2f %%", glast.max]];
        [_gasPredicted setText:[NSString stringWithFormat:@"%0.2f %%", 100*glast.max/3.8]];
    }
    if ([spiroArr count] == 0) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"No Data"
                                     message:@"How about taking a Spirometry test now?"
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
    } else if ([gasArr count] ==0) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"No Data"
                                     message:@"How about taking a exhaled Carbon Dioxide test now?"
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

@end
