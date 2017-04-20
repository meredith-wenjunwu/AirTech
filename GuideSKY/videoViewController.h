//
//  videoViewController.h
//  AirTech
//
//  Created by WuWenjun on 4/20/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface videoViewController: UIViewController
@property (nonatomic) AVPlayer *avPlayer;

@property (weak, nonatomic) IBOutlet UIView *vView;
@property (weak, nonatomic) IBOutlet UIButton *next;
- (IBAction)NextScreen:(UIButton *)sender;

@end
