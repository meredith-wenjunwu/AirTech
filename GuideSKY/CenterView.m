//
//  CenterView.m
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/10.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import "CenterView.h"
#import "MianTabrViewController.h"
@interface CenterView()
{
    NSTimer *timer;
    NSTimer *timer2;
    int currMinute;
    int currSeconds;
    BOOL canStart;
    BOOL isSpirometry;
    BOOL isSimulation;
    int threshold;
    JQFMDB *db;
    int test;
}
@end

@implementation CenterView
AppDelegate *appdelegate;
@synthesize bleShield;
@synthesize tableData;
@synthesize spirometry;
@synthesize tableTime;
@synthesize realSpirometry;


- (IBAction)Cancelonclick:(id)sender {
    [timer invalidate];
    
    NSString *s = @"0";
    NSData *d = [s dataUsingEncoding:NSUTF8StringEncoding];
    if (bleShield.activePeripheral.state == CBPeripheralStateConnected) {
        [bleShield write:d];
    }
    
    [tableData removeAllObjects];
    [tableTime removeAllObjects];
    [self removeFromSuperview];
}


- (IBAction)connectBluetooth:(id)sender {
    [self.realSpirometry setHidden:YES];
    [self.realSpirometry setEnabled:YES];
    if (bleShield.activePeripheral.state != CBPeripheralStateConnected) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Bluetooth"];
    }
    [tableData removeAllObjects];
    [tableTime removeAllObjects];
    if ([sender tag] == 3) {
        isSpirometry = YES;
        isSimulation = NO;
        threshold = 18;
        [self.spirometry setTitle:@"Spirometry" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Spiro"];
        [self.blowMessage setText:@"Now, Blow into the Spirometer with Full Effort!"];
        [self.blowMessage setFont:[UIFont italicSystemFontOfSize:25]];
    } else if ([sender tag]== 2) {
        isSpirometry = NO;
        isSimulation = NO;
        threshold = 51;
        [self.gasAnalysis setTitle:@"Gas Analysis" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Spiro"];
        [self.blowMessage setText:@"Now, Blow into the Gas Analyzer normally!"];
        [self.blowMessage setFont:[UIFont italicSystemFontOfSize:25]];
    } else {
        isSpirometry = YES;
        isSimulation = YES;
        threshold = 18;
        [self.spirometry setTitle:@"Spirometry" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Bluetooth"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Spiro"];
        [self.blowMessage setText:@"Now, Blow into the Spirometer with Full Effort!"];
        [self.blowMessage setFont:[UIFont italicSystemFontOfSize:25]];
    }
    [self.realSpirometry setHidden:YES];
    
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Bluetooth"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Bluetooth"]!=YES) {
        [self removeFromSuperview];
        [self.delegate buttonPressed:isSpirometry];
    } else {
        [self.spirometry setHidden:YES];
        [self.spirometry setEnabled:NO];
        [self.gasAnalysis setHidden:YES];
        [self.gasAnalysis setEnabled:NO];
        [self.blowMessage setHidden:NO];
        if (isSpirometry) {
            [self.timeLeftLabel setHidden:NO];
            [self.time setText:@"6"];
            [self.time setHidden:NO];
        } else {
            [self.timeLeftLabel setHidden:YES];
            [self.time setHidden:YES];
        }
        NSString *s;
        
        if (isSpirometry && isSimulation) {
            [self getdata];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Bluetooth"];
        } else if (!isSimulation){
            s = @"2";
            NSData *d;
        
            d = [s dataUsingEncoding:NSUTF8StringEncoding];
            if (bleShield.activePeripheral.state == CBPeripheralStateConnected) {
                [bleShield write:d];
            }
        }else{
            s = @"1";
            NSData *d;
            
            d = [s dataUsingEncoding:NSUTF8StringEncoding];
            if (bleShield.activePeripheral.state == CBPeripheralStateConnected) {
                [bleShield write:d];
            }

        }
        canStart = true;
        if ([tableData count] == 0) {
            canStart = false;
            [self waitForResponse:10];
        }
        if (canStart) {
            [self startup];
        }
        
    }
    
}

-(void) waitForResponse:(int) seconds {
    currMinute=0;
    currSeconds=seconds;
    timer2=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitingFired) userInfo:nil repeats:YES];
}

-(void)waitingFired {
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if ([tableData count] == 0) {
            if(currSeconds==0)
            {
                currMinute-=1;
                currSeconds=59;
            }
            else if(currSeconds>0)
            {
                currSeconds-=1;
            }
            if(currMinute>-1) {
                [self.activityIndicator setHidden:NO];
                [self.activityIndicator startAnimating];
            }
        } else {
            canStart = true;
            currSeconds = -1;
        }
    }
    else {
        [timer2 invalidate];
        
        if ([tableData count] >= threshold) {
            [self removeFromSuperview];
            [self.delegate buttonPressed:isSpirometry];
        } else {
            if (canStart) {
                [self startup];
            } else {
                [self.activityIndicator setHidden:YES];
                [self.activityIndicator stopAnimating];
                [self.blowMessage setText:@"Data not received!"];
                canStart = false;
                [self.realSpirometry setHidden:NO];
                
                if (isSpirometry) {
                    [self.spirometry setEnabled:YES];
                    [self.spirometry setHidden:NO];
                    [self.spirometry setTitle:@"TRY AGAIN" forState:UIControlStateNormal];
                } else {
                    [self.gasAnalysis setEnabled:YES];
                    [self.gasAnalysis setHidden:NO];
                    [self.gasAnalysis setTitle:@"TRY AGAIN" forState:UIControlStateNormal];
                }
                NSString *s = @"0";
                NSData *d = [s dataUsingEncoding:NSUTF8StringEncoding];
                if (bleShield.activePeripheral.state == CBPeripheralStateConnected) {
                    [bleShield write:d];
                }
            }
        }
        
    }
    
}

-(void)startup {
    currMinute=0;
    
    if (isSpirometry && !isSimulation) {
        currSeconds=6;
    } else if (isSpirometry && isSpirometry) {
        currSeconds = 10;
    } else {
        currSeconds = 25;
    }
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1 && currSeconds <= 6)
            if (isSpirometry)
                [self.time setText:[NSString stringWithFormat:@"%i",currSeconds]];
    }
    else
    {
        [timer invalidate];
        while ([tableData count] < threshold) {
            [tableData addObject:@(0)];
        }
        if (isSpirometry) {
            if ([self isvalid]) {
                [self removeFromSuperview];
                [self.delegate buttonPressed:isSpirometry];
            }
        } else {
            [self removeFromSuperview];
            [self.delegate buttonPressed:isSpirometry];
        }
    
    }
}
    

- (id)initWithFrame:(CGRect)frame
{
    test = 0;
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"CenterView" owner:self options:nil] lastObject];
        tableData = [Global array];
        self.frame = [UIScreen mainScreen].bounds;
        appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        bleShield = appdelegate.bleShield;
        db = [JQFMDB shareDatabase:@"All"];
        
        
        [self.blowMessage setHidden:YES];
        [self.timeLeftLabel setHidden:YES];
        [self.time setHidden:YES];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
        
        
    }
    return self;
}

- (BOOL) isvalid {
    tableTime = [[NSMutableArray alloc] init];
    [_activityIndicator stopAnimating];
    [_activityIndicator setHidden:YES];
    NSArray *userValue = [db jq_lookupTable:@"predictedValue" dicOrModel:[Predicted class] whereFormat:nil];
    Predicted *p = userValue[0];
    double pefStandard = p.pef;
    double fvcStandard = p.fvc;
    
    float a[18], b[18], c[18];
    
    float max = -1;
    float maxTime = -1;
    int j = 0;
    for (int i = 0; i < 18; i++) {
        float f = [self.tableData[i] floatValue];
        if (f > 0.1) {
            j = i;
        }
        a[i] = f;
        b[i] = 0.005556;
        if (f > max) {
            max = f;
            maxTime = i;
        }
        [tableTime addObject:@((float)i*1/180)];
    }
    //trapzoidal integral
    vDSP_vtrapz(a, 1, b, c, 1, 18);
    double PEF = (double) max;
    
    if (maxTime > 3) {
        [self.timeLeftLabel setHidden:YES];
        [self.time setHidden:YES];
        [self.spirometry setEnabled:YES];
        [self.spirometry setTitle:@"TRY AGAIN" forState:UIControlStateNormal];
        [self.spirometry setHidden:NO];
        [self.blowMessage setText:@"Blow out faster!"];
        [self.blowMessage setFont:[UIFont boldSystemFontOfSize:20]];
        return false;
    } else if (c[j]-c[j-5] > 0.1 && j < 10) {
        [self.timeLeftLabel setHidden:YES];
        [self.time setHidden:YES];
        [self.spirometry setEnabled:YES];
        [self.spirometry setTitle:@"TRY AGAIN" forState:UIControlStateNormal];
        [self.spirometry setHidden:NO];
        [self.blowMessage setText:@"Blow out longer!"];
        [self.blowMessage setFont:[UIFont boldSystemFontOfSize:20]];
        return false;
    } else if (pefStandard - PEF > 60) {
        [self.timeLeftLabel setHidden:YES];
        [self.time setHidden:YES];
        [self.spirometry setEnabled:YES];
        [self.spirometry setTitle:@"TRY AGAIN" forState:UIControlStateNormal];
        [self.spirometry setHidden:NO];
        [self.blowMessage setText:@"Blast out harder!"];
        [self.blowMessage setFont:[UIFont boldSystemFontOfSize:20]];
        return false;
    } else if (fvcStandard - c[17] > 0.15) {
        [self.timeLeftLabel setHidden:YES];
        [self.time setHidden:YES];
        [self.spirometry setEnabled:YES];
        [self.spirometry setTitle:@"TRY AGAIN" forState:UIControlStateNormal];
        [self.spirometry setHidden:NO];
        [self.blowMessage setText:@"Deeper breath!"];
        [self.blowMessage setFont:[UIFont boldSystemFontOfSize:20]];
        return false;
    }
    
    NSDate *now = [NSDate date];
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: now];
    NSDate *new = [NSDate dateWithTimeInterval: seconds sinceDate: now];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy/MM/dd";
    NSString *dateS = [df stringFromDate:new];
    
    
    Spirometry *s = [[Spirometry alloc]init];
//    s.values =  [[NSArray alloc] initWithArray:tableData copyItems:YES];
    s.times = [[NSArray alloc] initWithArray:tableTime copyItems:YES];
    s.date = dateS;
    s.FEV1 = (double) c[3];
    s.FVC = (double) c[17];
    s.PEF = PEF;
    
    [db jq_insertTable:@"spirometryTable" dicOrModel:s];
//    NSArray *spiroArr = [db jq_lookupTable:@"spirometryTable" dicOrModel:[Spirometry class] whereFormat:nil];
//    Spirometry *last = [spiroArr lastObject];
    return true;
    
}

- (void) getdata {
    
    if (test == 0) {
        float s[18] = {0.05, 54.2, 443.6, 142.4, 73.3, 42.1, 24.5, 19.9, 14.2, 7.4, 5.1, 3.2, 2.8, 1.4, 0.5, 0.01, 0.07, 0.02};
        float num = s[0];
        [tableData addObject:@(num)];
        for (int i = 1; i < 18; i++) {
            num = s[i];
            float j = (arc4random_uniform(150)) / 10.0 / i - 7.0/i;
            if (j + num < 0) {
                [tableData addObject:@(num)];
            } else {
                [tableData addObject:@((float)j + num)];
            }
        }
    } else if (test == 1){
        float s2[18] = {0.05, 54.2, 383.6, 102.4, 63.3, 42.1, 24.5, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01};
        float num = s2[0];
        [tableData addObject:@(num)];
        for (int i = 1; i < 18; i++) {
            num = s2[i];
            float j = 0.002;
            if (j + num < 0) {
                [tableData addObject:@(num)];
            } else {
                [tableData addObject:@((float)j + num)];
            }
        }

    } else if(test == 2) {
        float s3[18] = {0.05, 54.2, 233.6, 122.4, 90.6, 83.8, 73.8, 50.2, 14.2, 7.4, 5.1, 3.2, 2.8, 1.4, 0.5, 0.01, 0.07};
        float num = s3[0];
        [tableData addObject:@(num)];
        for (int i = 1; i < 18; i++) {
            num = s3[i];
            float j = 0.002;
            if (j + num < 0) {
                [tableData addObject:@(num)];
            } else {
                [tableData addObject:@((float)j + num)];
            }
        }
    } else if (test == 3) {
        float s4[18] = {0.05, 54.2, 113.6, 202.4, 363.3, 372.1, 424.5, 510.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01};
        float num = s4[0];
        [tableData addObject:@(num)];
        for (int i = 1; i < 18; i++) {
            num = s4[i];
            float j = 0.002;
            if (j + num < 0) {
                [tableData addObject:@(num)];
            } else {
                [tableData addObject:@((float)j + num)];
            }
        }
        
    }
//    float s[18] = {0.05, 54.2, 383.6, 102.4, 63.3, 42.1, 24.5, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01};
//    float num = s[0];
//    [tableData addObject:@(num)];
//    for (int i = 1; i < 18; i++) {
//        num = s[i];
//        float j = (arc4random_uniform(150)) / 10.0 / i - 7.0/i;
//        if (j + num < 0) {
//            [tableData addObject:@(num)];
//        } else {
//            [tableData addObject:@((float)j + num)];
//        }
//    }
    
}





- (IBAction)longer:(id)sender {
    test = 1;
}

- (IBAction)harder:(id)sender {
    test = 2;
}

- (IBAction)faster:(id)sender {
    test = 3;
}
@end
