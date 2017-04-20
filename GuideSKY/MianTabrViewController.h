//
//  MianTabrViewController.h
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/9.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "LoginViewController.h"
#include "LineViewController.h"
#include "JQFMDB.h"
#include "Spirometry.h"

@protocol tabBarViewDeleage
    @optional
- (void)tabBarViewSelectedItem:(NSInteger )seleteIndex;
- (void)tabBarViewCenterItemClick;

@end

@interface MianTabrViewController : UITabBarController
/*-----是否隐藏tabbarView------*/
- (void)buttonPressed:(BOOL)isSpirometry;
+ (void)HiddenTabbar:(BOOL)isHidden;
-(void)resultInvalid:(NSString*) s;
@end

//创建自定义试图
@interface TabBarView : UIView
/*----响应事件代理-----*/
@property(nonatomic,assign)id<tabBarViewDeleage> delegate;
/*----是否显示中间按钮-----*/
@property(nonatomic,assign)BOOL showCenter;


@property(nonatomic,assign)NSInteger itemSelectedIndex;
/*----初始化单例-----*/
+ (TabBarView *)defaultManager;
/*----填充数据-----*/
- (void)initWithItemImages:(NSArray *)normalArray selecteArray:(NSArray *)selecteArray titleArray:(NSArray *)titleArray;
/*----是否隐藏tabbar-----*/
-(void)TabbarHidden:(BOOL)isHidden;
@end




