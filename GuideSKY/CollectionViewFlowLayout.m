//
//  CollectionViewFlowLayout.m
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/9.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import "CollectionViewFlowLayout.h"

@implementation CollectionViewFlowLayout
- (void)prepareLayout
{
    [super prepareLayout];
 
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    // 设置cell 大小
    self.itemSize = [UIScreen mainScreen].bounds.size;
    
    // 设置滑动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置间距
    self.minimumLineSpacing = 0;
}

@end
