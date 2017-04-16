//
//  UIViewController+Bluetooth.m
//  AirTech
//
//  Created by WuWenjun on 4/14/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import "BluetoothViewController.h"


@interface BluetoothViewController ()
{
    NSMutableArray *tableData;
}

@end

@implementation BluetoothViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    tableData = [NSMutableArray array];
    
    
    bleShield = [[BLE alloc] init];
    [bleShield controlSetup];
    bleShield.delegate = self;
    [self.btnDisconnect setEnabled: NO];
    [self.btnDisconnect setHidden:YES];
    
    
}

-(void) connectionTimer:(NSTimer *)timer
{
    if(bleShield.peripherals.count > 0)
    {
        [bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
    }
    else
    {
        [_activityIndicator stopAnimating];
    }
    [_btnConnect setEnabled:YES];
}

- (IBAction)BLEShieldScan:(id)sender
{
    if (bleShield.activePeripheral)
        if(bleShield.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
            return;
        }
    
    if (bleShield.peripherals)
        bleShield.peripherals = nil;
    
    [bleShield findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    [_activityIndicator startAnimating];
    [_btnConnect setEnabled:NO];

}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSLog(@"%@", s);
    double v = [s doubleValue];
    [tableData addObject:@(v)];
    
}

NSTimer *rssiTimer;

-(void) readRSSITimer:(NSTimer *)timer
{
    [bleShield readRSSI];
}



- (void) bleDidDisconnect
{
    NSLog(@"bleDidDisconnect");
    
    [_btnConnect setEnabled:YES];
    [_btnDisconnect setEnabled:NO];
    [_btnDisconnect setHidden:YES];
    [_activityIndicator stopAnimating];
    
}

-(void) bleDidConnect
{
    
    NSLog(@"bleDidConnect");
    NSString *s = @"1";
    NSData *d;
    
    d = [s dataUsingEncoding:NSUTF8StringEncoding];
    if (bleShield.activePeripheral.state == CBPeripheralStateConnected) {
        [bleShield write:d];
        }
    [_activityIndicator stopAnimating];
    [_btnConnect setEnabled:NO];
    [_btnConnect setHidden:YES];
    [_btnDisconnect setHidden:NO];
    [_btnDisconnect setEnabled:YES];

}

@end
