//
//  MianTabrViewController.m
//  AirTech
//
//  Created by Wenjun Wu on 2017/1/9.
//  Copyright © 2017 Wenjun Wu. All rights reserved.
//

#import "MianTabrViewController.h"
#import "UIVerticalButton.h"
#import <objc/runtime.h>
#import "CenterView.h"
/*-----获取屏幕尺寸------*/
#define  SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define  SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface MianTabrViewController ()<tabBarViewDeleage>
/*-----懒加载初始化数据------*/
@property(nonatomic,strong)NSArray *normalArray;
@property(nonatomic,strong)NSArray *selectedArray;
@property(nonatomic,strong)NSArray *titlesArray;
@property(nonatomic,strong)TabBarView *tabBarView;
@property(nonatomic,strong)UIVerticalButton *seletBtn;
@property JQFMDB *db;

@end

@implementation MianTabrViewController
/*-----是否隐藏tabbarView------*/
+(void)HiddenTabbar:(BOOL)isHidden
{
    [[TabBarView defaultManager] TabbarHidden:isHidden];
}
- (TabBarView *)tabBarView
{
  
    if (!_tabBarView) {
        _tabBarView = [TabBarView defaultManager];
    }
    return _tabBarView;
}
- (NSArray *)normalArray
{
    if (!_normalArray) {
        _normalArray = @[@"iconfont-Nor",@"iconfont-Sel",@"iconfont-Hist",@"iconfont-Pers"];
    }
    return _normalArray;
}
- (NSArray *)selectedArray
{
    if (!_selectedArray) {
        _selectedArray = @[@"iconfont-Nor",@"iconfont-Sel",@"iconfont-Hist",@"iconfont-Pers"];
    }
    
    return _selectedArray;
}
- (NSArray *)titlesArray
{
    if (!_titlesArray) {
        _titlesArray = @[@"Home",@"Bluetooth",@"History",@"Personal"];
    }
    return _titlesArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar removeFromSuperview];
    _db = [JQFMDB shareDatabase:@"All"];
    [self.tabBarView initWithItemImages:self.normalArray selecteArray:self.selectedArray titleArray:self.titlesArray];
    self.tabBarView.showCenter = true;
    self.tabBarView.delegate = self;
    self.tabBarView.itemSelectedIndex = 0;
    [self.view addSubview:self.tabBarView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:false];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"registered"]){
        NSString * storyboardName = @"MianTabr";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:vc animated:NO completion:nil];
    }
}
-(void)resultInvalid:(NSString*) s{

        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"TRY AGAIN"
                                     message:s
                                     preferredStyle:UIAlertControllerStyleAlert];
    
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];

}

-(void)buttonPressed: (BOOL) isSpirometry{
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Bluetooth"];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"Bluetooth"]!=YES) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Ooooops"
                                     message:@"You must connect to Bluetooth first!"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        if (isSpirometry) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Spiro"];
        } else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Spiro"];
        }
        [self performSegueWithIdentifier: @"presentData" sender: self];
    }
    
}


- (void)tabBarViewCenterItemClick
{
    //可以添加弹出动画------
    CenterView *view = [[CenterView alloc]init];
    view.delegate = self;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
   // NSLog(@"点击了中心按钮");
}
- (void)tabBarViewSelectedItem:(NSInteger)seleteIndex
{
    self.selectedIndex = seleteIndex;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [self.tabBarView removeFromSuperview];
     self.tabBarView = nil;
    
}
/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
 */
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    BOOL s = [[NSUserDefaults standardUserDefaults] boolForKey:@"Spiro"];
//     //Get the new view controller using [segue destinationViewController].
//     //Pass the selected object to the new view controller.
//    [MianTabrViewController HiddenTabbar:false];
//    [super prepareForSegue:segue sender:sender];
//    
//    if ([segue.identifier isEqualToString:@"presentData"] && s) {
//        LineViewController *controller = segue.destinationViewController;
//        NSArray *spiroArr = [_db jq_lookupTable:@"spirometryTable" dicOrModel:[Spirometry class] whereFormat:nil];
//        Spirometry *slast = [spiroArr lastObject];
//        controller.arrayOfValues = slast.values;
//        controller.arrayOfDates = slast.times;
//    }
//
//}


@end

@interface TabBarView()
@property(nonatomic,strong)UIButton *centerButton;
@property(nonatomic,strong)NSMutableArray *btnArray;
@end
static TabBarView *DefaultManager = nil;
@implementation TabBarView
//销毁单利对象
- (void)removeFromSuperview
{
    [super removeFromSuperview];
     DefaultManager = nil;
}
- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

+ (TabBarView *)defaultManager {
    if (!DefaultManager) DefaultManager = [[self allocWithZone:NULL] init];
    return DefaultManager;
}

- (void)initWithItemImages:(NSArray *)normalArray selecteArray:(NSArray *)selecteArray titleArray:(NSArray *)titleArray
{
    self.frame = CGRectMake(0, SCREENHEIGHT-49, SCREENWIDTH, 49);
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = false;
  
    [self createUI:normalArray selecteArray:selecteArray titleArray:titleArray];

}
/*------中心按钮超出部分添加响应----*/
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * view = [super hitTest:point withEvent:event];
    if (view == nil) {
        // 转换坐标系
        CGPoint newPoint = [self.centerButton convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.centerButton.bounds, newPoint)) {
            view = self.centerButton;
        }
    }
    return view;
}
/*-----创建tabbarView页面------*/
- (void)createUI:(NSArray *)normalArray selecteArray:(NSArray *)selecteArray titleArray:(NSArray *)titleArray
{
    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.centerButton addTarget:self action:@selector(centerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.centerButton setImage:[UIImage imageNamed:@"人民币"] forState:UIControlStateNormal];
    [self addSubview:self.centerButton];
    for(int i = 0;i<titleArray.count;i++){
            UIVerticalButton *btn = [UIVerticalButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:normalArray[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:selecteArray[i]] forState:UIControlStateSelected];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            btn.tag = i;
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [self.btnArray addObject:btn];

    }
 
   
}
-(void)TabbarHidden:(BOOL)isHidden
{
    float duration = 0.5;

        [UIView animateWithDuration:duration animations:^{
            if (isHidden) {
                self.transform = CGAffineTransformMakeTranslation(0, 60);

            }
            else
            {
                self.transform = CGAffineTransformIdentity;
            }
            
        }];
   
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self buttonFrame];
}
/** 设置坐标 */
- (void)buttonFrame
{
    /** 中间按钮的宽高 */
    CGFloat centerButtonWH = 60;
    /** 普通按钮的高度 */
    CGFloat buttonHeight = 48.5;
    /** 普通按钮的宽度 */
    CGFloat buttonWidth = self.frame.size.width/self.btnArray.count;
    CGFloat centerButtonX = (self.frame.size.width - centerButtonWH)*0.5;
    
    if (_showCenter) {
        self.centerButton.frame = CGRectMake(centerButtonX, self.frame.size.height - centerButtonWH, centerButtonWH, centerButtonWH);
        
        buttonWidth = (self.frame.size.width - centerButtonWH - 20)/self.btnArray.count;
    }
    CGFloat buttonX = 0;
    for (int i = 0; i< self.btnArray.count; i++) {
        UIVerticalButton *obj = self.btnArray[i];
        if (_showCenter && obj.tag == 2) {
            buttonX += centerButtonWH + 20;
        }
        obj.frame = CGRectMake(buttonX, 0.5, buttonWidth, buttonHeight);
        buttonX += buttonWidth;
    }
   



}
/** 点击编程按钮 */
- (void)buttonClick:(UIVerticalButton *)btn
{
    
    if (self.delegate) {
        [self.delegate tabBarViewSelectedItem:btn.tag];
    }
    self.itemSelectedIndex = btn.tag;
}
/** 设置选中的button */
- (void)setItemSelectedIndex:(NSInteger)itemSelectedIndex
{
    for (UIVerticalButton *btn in self.btnArray) {
        btn.selected = false;
        if (btn.tag == itemSelectedIndex) {
            btn.selected  = true;
        }
    }
}
/** 点击中心按钮 */
- (void)centerButtonClick
{
    [self.delegate tabBarViewCenterItemClick];

    
}


@end



