//
//  LoginViewController.h
//  AirTech
//
//  Created by Wenjun Wu on 2017/1/9.
//  Copyright © 2017 Wenjun Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JQFMDB.h"


@interface LoginViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *label;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

// Database Actions
- (IBAction)save:(id)sender;
- (void)load;


@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *weight;
@property (strong, nonatomic) IBOutlet UITextField *age;
@property (strong, nonatomic) IBOutlet UISegmentedControl *gender;
@property (weak, nonatomic) IBOutlet UITextField *height;


@end
