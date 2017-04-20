//
//  videoViewController.m
//  AirTech
//
//  Created by WuWenjun on 4/20/17.
//  Copyright © 2017 Georgia Tech. All rights reserved.
//

#import "videoViewController.h"

@implementation videoViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [_next setEnabled:YES];
    [_next setHidden:NO];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"What Is a Spirometry Test.mp4" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    self.avPlayer = [AVPlayer playerWithURL:fileURL];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    AVPlayerLayer *videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    videoLayer.frame = self.vView.bounds;
    videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.vView.layer addSublayer:videoLayer];
    
    [self.avPlayer play];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.avPlayer pause];
    self.avPlayer=nil;
}
- (IBAction)NextScreen:(UIButton *)sender {
    [self.avPlayer pause];
    self.avPlayer=nil;
}

@end
