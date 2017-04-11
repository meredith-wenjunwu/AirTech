//
//  UIVerticalButton.m
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/9.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import "UIVerticalButton.h"

@implementation UIVerticalButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIImageView *imageView  = self.imageView;
    CGPoint center=imageView.center;
    center.x =  self.frame.size.width/2;
    center.y =  self.frame.size.height/2 - 8;
    imageView.bounds = CGRectMake(0, 0, self.frame.size.height/2,  self.frame.size.height/2);
    imageView.center = center;
    UILabel *label = self.titleLabel;
    CGRect newFrame = label.frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = CGRectGetMaxY(imageView.frame);
    newFrame.size.width = self.frame.size.width;
    newFrame.size.height = self.frame.size.height-imageView.frame.size.height-8;
    label.frame = newFrame;
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
}
@end
