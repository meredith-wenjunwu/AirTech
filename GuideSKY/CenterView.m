//
//  CenterView.m
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/10.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import "CenterView.h"
#import "MianTabrViewController.h"

@implementation CenterView


- (IBAction)onclick:(id)sender {
     [self removeFromSuperview];
}
- (IBAction)connectBluetooth:(id)sender {
    [self removeFromSuperview];
    [self.delegate buttonPressed];
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"CenterView" owner:self options:nil] lastObject];
        self.frame = [UIScreen mainScreen].bounds;
       
    }
    return self;
}


@end
