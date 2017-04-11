//
//  PushViewController.m
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/10.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import "PushViewController.h"
#import "MianTabrViewController.h"
@interface PushViewController ()

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //是否允许右划返回
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //显示tabbar
    [MianTabrViewController HiddenTabbar:false];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //隐藏tabbar
    [MianTabrViewController HiddenTabbar:true];
}


@end
