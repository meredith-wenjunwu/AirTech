//
//  GuideViewController.m
//  GuideSKY
//
//  Created by yijiaanhao on 2017/1/9.
//  Copyright © 2017年 谢家宝. All rights reserved.
//

#import "GuideViewController.h"
#import "CollectionViewFlowLayout.h"
#import "GuideCollectionViewCell.h"
@interface GuideViewController ()<UICollectionViewDelegateFlowLayout>
/**************** 存放图片的数组  *******************/
@property(nonatomic,strong)NSArray *imageViewArray;
@end

@implementation GuideViewController
- (NSArray *)imageViewArray
{
    if (!_imageViewArray) {
        _imageViewArray = @[@"引导-0",@"引导-1"];
        
    }
    return _imageViewArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    

  

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    return self.imageViewArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    GuideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.bgImgaeView.image = [UIImage imageNamed:_imageViewArray[indexPath.row]];
    if (indexPath.row == _imageViewArray.count-1) {
        cell.pushButton.hidden = false;
    }
    else
    {
        cell.pushButton.hidden = true;

    }
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)EnterNow:(id)sender {
    
}
@end
