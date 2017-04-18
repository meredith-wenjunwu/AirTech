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
    int threshold;
}
@end

@implementation CenterView
AppDelegate *appdelegate;
@synthesize bleShield;
@synthesize tableData;
@synthesize spirometry;


- (IBAction)Cancelonclick:(id)sender {
    [timer invalidate];
    
    NSString *s = @"0";
    NSData *d = [s dataUsingEncoding:NSUTF8StringEncoding];
    if (bleShield.activePeripheral.state == CBPeripheralStateConnected) {
        [bleShield write:d];
    }
    [tableData removeAllObjects];
    [self removeFromSuperview];
}


- (IBAction)connectBluetooth:(id)sender {
    [tableData removeAllObjects];
    if ([sender tag] == 1) {
        isSpirometry = YES;
        threshold = 61;
        [self.spirometry setTitle:@"Spirometry" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Spiro"];
        [self.blowMessage setText:@"Now, Blow into the Spirometer!"];
        [self.blowMessage setFont:[UIFont italicSystemFontOfSize:25]];
    } else {
        isSpirometry = NO;
        threshold = 13;
        [self.gasAnalysis setTitle:@"Gas Analysis" forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Spiro"];
        [self.blowMessage setText:@"Now, Blow into the Gas Analyzer!"];
        [self.blowMessage setFont:[UIFont italicSystemFontOfSize:25]];
    }
    
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
        [self.timeLeftLabel setHidden:NO];
        [self.time setText:@"6"];
        [self.time setHidden:NO];
        
        NSString *s = @"1";
        NSData *d;
        
        d = [s dataUsingEncoding:NSUTF8StringEncoding];
        if (bleShield.activePeripheral.state == CBPeripheralStateConnected) {
            [bleShield write:d];
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
    currSeconds=6;
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
        if(currMinute>-1)
            [self.time setText:[NSString stringWithFormat:@"%i",currSeconds]];
    }
    else
    {
        [timer invalidate];
        while ([tableData count] < threshold) {
            [tableData addObject:@(0)];
        }
        [self removeFromSuperview];
        [self.delegate buttonPressed:isSpirometry];
        
        
        
#pragma implement validation check and then tableData --> db
        //        [self.timeLeftLabel setHidden:YES];
        //        [self.time setHidden:YES];
        //        [self.spirometry setEnabled:YES];
        //        [self.spirometry setTitle:@"TRY AGAIN" forState:UIControlStateNormal];
        //        [self.spirometry setHidden:NO];
        //        [self.blowMessage setText:@"Exhale with FULL EFFORT!"];
        //        [self.blowMessage setFont:[UIFont boldSystemFontOfSize:20]];
#pragma move to data visualization
        //[tableData removeAllObjects];
    }
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"CenterView" owner:self options:nil] lastObject];
        tableData = [Global array];
        self.frame = [UIScreen mainScreen].bounds;
        appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        bleShield = appdelegate.bleShield;
        
        
        [self.blowMessage setHidden:YES];
        [self.timeLeftLabel setHidden:YES];
        [self.time setHidden:YES];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
        
        
    }
    return self;
}


@end
