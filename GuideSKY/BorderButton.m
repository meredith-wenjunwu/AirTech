//
//  BorderButton.m
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/9.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import "BorderButton.h"

@implementation BorderButton

-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius=cornerRadius;
}
-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor=borderColor.CGColor;
}
-(void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth=borderWidth;
}

@end
