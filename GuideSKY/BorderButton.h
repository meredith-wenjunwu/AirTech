//
//  BorderButton.h
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/9.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
/***********对button扩展窗口属性************/
@interface BorderButton : UIButton
@property (nonatomic,assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic,assign) IBInspectable UIColor* borderColor;
@property (nonatomic,assign) IBInspectable CGFloat borderWidth;

@end
