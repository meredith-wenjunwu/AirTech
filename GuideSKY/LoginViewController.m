//
//  LoginViewController.m
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/9.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property JQFMDB *db;
@property NSDictionary *tree;
- (void)readJSON;
- (int)getAgeIndex;
@end

@implementation LoginViewController
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

- (IBAction)save:(id)sender {
    if ([_name.text isEqualToString:@""] || [_email.text isEqualToString:@""] || [_weight.text isEqualToString:@""] || [_height.text isEqualToString:@""] || [_email.text isEqualToString:@""] || [_age.text isEqualToString:@""]) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Ooooops"
                                     message:@"You must complete all fields!"
                                     preferredStyle:UIAlertControllerStyleAlert];
    
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];

    } else {
        _db = [JQFMDB shareDatabase:@"All"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //save name
        NSString *saveName = _name.text;
        [defaults setObject:saveName forKey:@"Name"];
        
        //save email
        NSString *saveEmail = _email.text;
        [defaults setObject:saveEmail forKey:@"Email"];
        
        //save weight
        NSString *saveWeight = _weight.text;
        float w = [saveWeight floatValue];
        [defaults setFloat:w forKey:@"Weight"];
        
        //save height
        NSString *saveHeight = _height.text;
        NSInteger h = [saveHeight integerValue];
        [defaults setInteger:h forKey:@"Height"];
        
        //save age
        NSString *saveAge = _age.text;
        NSInteger a = [saveAge integerValue];
        [defaults setInteger:a forKey:@"Age"];
        
        //save gender
        NSInteger G = _gender.selectedSegmentIndex;
        [defaults setInteger:G forKey:@"Gender"];
        
        
        int ageIndex = [self getAgeIndex];
        NSString *k = [NSString stringWithFormat:@"%i", ageIndex];
        NSDictionary *currentNode = [self.tree objectForKey:k];
        NSString *heightK = [self getHeightKey:(int)h];
        NSDictionary *currentArray = [currentNode objectForKey:heightK];
        
        if (![_db jq_isExistTable:@"predictedValue"]) {
            NSLog(@"No predicted value!");
            [_db jq_createTable:@"predictedValue" dicOrModel:@{@"FVC":@"TEXT", @"FEV1":@"TEXT", @"FEV1/FVC":@"TEXT", @"PEF":@"TEXT"}];
        }
        [_db jq_insertTable:@"predictedValue" dicOrModel:currentArray];
    }
}



- (void)load{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //load Name
    NSString *loadName = [defaults objectForKey:@"Name"];
    [_name setText:loadName];
    
    //load Email
    NSString *loadEmail = [defaults objectForKey:@"Email"];
    [_email setText:loadEmail];
    
    //load weight
    float loadWeight = [defaults floatForKey:@"Weight"];
    NSString *weightS = [NSString stringWithFormat:@"%0.2f", loadWeight];
    [_weight setText:weightS];
    
    //load height
    NSInteger loadHeight = [defaults integerForKey:@"Height"];
    NSString *heightS = [NSString stringWithFormat:@"%li", (long)loadHeight];
    [_height setText:heightS];
    
    //load age
    NSInteger loadAge = [defaults integerForKey:@"Age"];
    NSString *ageS = [NSString stringWithFormat:@"%li", (long)loadAge];
    [_age setText:ageS];
    
    //load gender
    NSInteger G = [defaults integerForKey:@"Gender"];
    [_gender setSelectedSegmentIndex:G];
    
}
- (IBAction)toHome:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    _name.delegate = self;
    _email.delegate = self;
    _weight.delegate = self;
    _age.delegate = self;
    _height.delegate = self;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"registered"]){
        [self load];
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"registered"];
    [self addDoneButton];
    [self readJSON];
}

- (void)addDoneButton {
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self.view action:@selector(endEditing:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    self.age.inputAccessoryView = keyboardToolbar;
    self.weight.inputAccessoryView = keyboardToolbar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) readJSON{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int G = (int)[defaults integerForKey:@"Gender"];
    NSString *filePath;
    if (G == 0) {
        filePath = [[NSBundle mainBundle] pathForResource:@"female" ofType:@"json"];
    } else {
        filePath = [[NSBundle mainBundle] pathForResource:@"male" ofType:@"json"];
    }
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    if (!myJSON) {
        NSLog(@"File couldn't be read!");
        return;
    } else {
        NSError *error =  nil;
        self.tree = [NSJSONSerialization JSONObjectWithData:[myJSON dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    }
}

- (int) getAgeIndex {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //load age
    int a = (int) [defaults integerForKey:@"Age"];
    
    int i = 0;
    int ageArray[13] = {17, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 65, 100};
    while (a > ageArray[i]) {
        i++;
    }
    return ageArray[i];
}

- (NSString *)getHeightKey:(int)AgeIndex {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //load height
    int h = (int) [defaults integerForKey:@"Height"];
    if (AgeIndex > 1 && h < 150) {
        return [NSString stringWithFormat:@"%i", 150];
    }
    int b = (h + 4) / 5 * 5;
    return [NSString stringWithFormat:@"%i", b];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
