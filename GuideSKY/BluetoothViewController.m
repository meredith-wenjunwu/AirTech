//
//  UIViewController+Bluetooth.m
//  AirTech
//
//  Created by WuWenjun on 4/14/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import "BluetoothViewController.h"
#import "AppDelegate.h"



@interface BluetoothViewController ()
{
    AppDelegate *appdelegate;
    BOOL write;
    int threshold;
    BOOL isSpirometry;
}

@end

@implementation BluetoothViewController
@synthesize tableData;


- (void)viewDidLoad
{
    [tableData removeAllObjects];
    write = false;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    tableData = [NSMutableArray array];
    [_activityIndicator setHidden:YES];
    
    _bleShield = appdelegate.bleShield;
    
    _bleShield.delegate = self;
    [self.btnDisconnect setEnabled: NO];
    [self.btnDisconnect setHidden:YES];
    tableData = [Global array];
}

-(void) connectionTimer:(NSTimer *)timer
{
    if(_bleShield.peripherals.count > 0)
    {
        [_bleShield connectPeripheral:[_bleShield.peripherals objectAtIndex:0]];
    }
    else
    {
        [_activityIndicator stopAnimating];
        [_activityIndicator setHidden:YES];
        [_btnConnect setEnabled:YES];
    }
}

- (IBAction)BLEShieldScan:(id)sender
{
    if (_bleShield.activePeripheral)
        if(_bleShield.activePeripheral.state == CBPeripheralStateConnected)
        {
            NSString *s = @"0";
            NSData *d;
            d = [s dataUsingEncoding:NSUTF8StringEncoding];
            if (_bleShield.activePeripheral.state == CBPeripheralStateConnected) {
                [_bleShield write:d];
            }
            [[_bleShield CM] cancelPeripheralConnection:[_bleShield activePeripheral]];
            [_btnConnect setHidden:NO];
            [_btnConnect setEnabled:YES];
            return;
        }
    
    if (_bleShield.peripherals)
        _bleShield.peripherals = nil;
    
    [_bleShield findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    [_activityIndicator setHidden:NO];
    [_activityIndicator startAnimating];
    [_btnConnect setEnabled:NO];

}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSLog(@"%@", s);
    double v = [s doubleValue];
    if (v > 0 || write) {
        isSpirometry  = [[NSUserDefaults standardUserDefaults] boolForKey:@"Spiro"];
        if (isSpirometry) {
            threshold = 121;
        } else {
            threshold = 13;
        }
        write = true;
        [tableData addObject:@(0)];
        [tableData addObject:@(v)];
    }
    
        
    if ([tableData count] >= threshold) {
        write = false;
        NSString *s = @"0";
        NSData *d;
        d = [s dataUsingEncoding:NSUTF8StringEncoding];
        if (_bleShield.activePeripheral.state == CBPeripheralStateConnected) {
            [_bleShield write:d];
        }

    }

}

NSTimer *rssiTimer;

-(void) readRSSITimer:(NSTimer *)timer
{
    [_bleShield readRSSI];
}



- (void) bleDidDisconnect
{
    write = false;
    NSLog(@"bleDidDisconnect");
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Bluetooth"];
    
    [_btnConnect setEnabled:YES];
    [_btnDisconnect setEnabled:NO];
    [_btnDisconnect setHidden:YES];
    [_activityIndicator setHidden:YES];
    [_activityIndicator stopAnimating];
    
}

-(void) bleDidConnect
{
    [_activityIndicator setHidden:YES];
    [_activityIndicator stopAnimating];
    [_btnConnect setHidden:YES];
    [_btnDisconnect setEnabled:YES];
    [_btnDisconnect setHidden:NO];
    [_btnConnect setEnabled:NO];
    
    NSString *s = @"1";
    NSData *d;
    
    d = [s dataUsingEncoding:NSUTF8StringEncoding];
    if (_bleShield.activePeripheral.state == CBPeripheralStateConnected) {
        [_bleShield write:d];
    }

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Bluetooth"];
    NSLog(@"bleDidConnect");
}

- (float)getRandomFloat {
    float i1 = (float)(arc4random_uniform(50000))/100 ;
    return i1;
}

@end
