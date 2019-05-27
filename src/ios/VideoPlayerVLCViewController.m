//
//  VideoPlayerVLCViewController.m
//  MobileVLCKiteTest
//
//  Created by Yanbing Peng on 9/02/16.
//  Copyright © 2016 Yanbing Peng. All rights reserved.
//

#import "VideoPlayerVLCViewController.h"
#import <MobileVLCKit/MobileVLCKit.h>
#import "VideoPlayerVLC.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface VideoPlayerVLCViewController ()<VLCMediaPlayerDelegate>
@property(strong, nonatomic) UIButton *closeButton;
@property(strong, nonatomic) VLCMediaPlayer *mediaPlayer;
@property(strong, nonatomic) UIView *mediaView;
@property(strong, nonatomic) UIActivityIndicatorView *indicatorView;
@end

@implementation VideoPlayerVLCViewController

-(id)init{
    if (self = [super init]){
        self.playOnStart = YES;
    }
    return  self;
}

- (void)viewDidLoad {
    NSLog(@"[VideoPlayerVLCViewController viewDidLoad]");
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor blackColor];
    //[self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.mediaView = [[UIView alloc] init];
    self.closeButton = [[UIButton alloc] init];
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    self.mediaPlayer = [[VLCMediaPlayer alloc] initWithOptions:@[@"--network-caching=150 --clock-jitter=0 --clock-synchro=0",@"--rtsp-tcp"]];
    
   
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.closeButton setTitle:@"×" forState:UIControlStateNormal];
    //[self.closeButton setFont:[UIFont systemFontOfSize:20]];
    self.closeButton.titleLabel.font = [UIFont systemFontOfSize:25];
    
    self.mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self.view addSubview:self.mediaView];
    [self.view addSubview:self.indicatorView];
    [self.view addSubview:self.closeButton];
    
    NSLayoutConstraint *closeButtonTopConstraint = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:10.0];
    NSLayoutConstraint *closeButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:30.0];
    NSLayoutConstraint *closeButtonHeightConstraint = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:15];
    NSLayoutConstraint *closeButtonWidthConstraint = [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:15];

    
    
    NSLayoutConstraint *mediaViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.mediaView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *mediaViewCenterHorizontallyConstraint = [NSLayoutConstraint constraintWithItem:self.mediaView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *mediaViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.mediaView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *mediaViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.mediaView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    
    [self.view addConstraint:closeButtonTopConstraint];
    [self.view addConstraint:closeButtonLeftConstraint];
    [self.view addConstraint:closeButtonHeightConstraint];
    [self.view addConstraint:closeButtonWidthConstraint];
    [self.view addConstraint:mediaViewWidthConstraint];
    //[self.view addConstraint:mediaViewHeightConstraint];
    [self.view addConstraint:mediaViewCenterHorizontallyConstraint];
    [self.view addConstraint:mediaViewTopConstraint];
    [self.view addConstraint:mediaViewBottomConstraint];
    
    self.mediaPlayer.delegate = self;
    self.mediaPlayer.drawable = self.mediaView;

    //self.indicatorView.center = self.mediaView.center;
    self.indicatorView.center = self.view.center;
    [self.indicatorView setHidesWhenStopped:YES];
    [self.indicatorView startAnimating];
    [self rotateBlock];
    [self.closeButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)showMessage:(NSString *)message {
    // 获取window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *showView = [[UIView alloc] init];
    showView.backgroundColor = [UIColor blackColor];
    showView.frame = CGRectMake(1, 1, 1, 1);
    showView.alpha = 1.0f;
    showView.layer.cornerRadius = 5.0f;
    showView.layer.masksToBounds = YES;
    [window addSubview:showView];
    
    UILabel *label = [[UILabel alloc] init];
    UIFont *font = [UIFont systemFontOfSize:15];
    CGRect labelRect = [message boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    label.frame = CGRectMake(10, 5, ceil(CGRectGetWidth(labelRect)), CGRectGetHeight(labelRect));
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [showView addSubview:label];
    showView.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - CGRectGetWidth(labelRect) - 20)/2, 100, CGRectGetWidth(labelRect)+20, CGRectGetHeight(labelRect)+10);
    [UIView animateWithDuration:2.5 animations:^{
        showView.alpha = 0;
    } completion:^(BOOL finished) {
        [showView removeFromSuperview];
    }];
    
}
-(void)rotateBlock {
    BOOL full = self.view.frame.size.width == ScreenWidth;
    if (full) { // 竖屏
        // 旋转view
        //self.view.transform = CGAffineTransformMakeRotation(M_PI/2); // 旋转90°
        //CGRect frame = [UIScreen mainScreen].applicationFrame; // 获取当前屏幕大小
        // 重新设置所有view的frame
        //self.view.bounds = CGRectMake(0, 0,frame.size.height ,frame.size.width);
        //self.mediaView.frame = self.view.bounds;
        UIScreen *screen = [UIScreen mainScreen];
        CGSize screenSize = screen.bounds.size;
        CGSize videoSize = self.mediaPlayer.videoSize;
        self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
        self.view.bounds = CGRectMake(0, 0,screenSize.height ,screenSize.width);
        //self.mediaView.frame = self.view.bounds;
        
        
            CGFloat ar = videoSize.width/(float)videoSize.height;
            CGFloat dar = screenSize.width/(float)screenSize.height;
            CGFloat scale;
        
            if (dar >= ar) {
                scale = screenSize.width/(float)videoSize.width;
            } else {
                scale = screenSize.height/(float)videoSize.height;
            }
            //self.mediaPlayer.scaleFactor = scale * screen.scale;
    } else { // 横屏
        // 旋转view
        //self.view.transform = CGAffineTransformMakeRotation(M_PI*2); // 旋转90°
        //CGRect frame = [UIScreen mainScreen].applicationFrame; // 获取当前屏幕大小
        // 重新设置所有view的frame
        //self.view.bounds = CGRectMake(0, 0,frame.size.width,frame.size.height);
        //self.mediaView.frame = self.view.bounds;
    }
//    UIScreen *screen = [UIScreen mainScreen];
//    CGSize screenSize = screen.bounds.size;
//    CGSize videoSize = self.mediaPlayer.videoSize;
//
//    CGFloat ar = videoSize.width/(float)videoSize.height;
//    CGFloat dar = screenSize.width/(float)screenSize.height;
//    CGFloat scale;
//
//    if (dar >= ar) {
//        scale = screenSize.width/(float)videoSize.width;
//    } else {
//        scale = screenSize.height/(float)videoSize.height;
//    }
//    self.mediaPlayer.scaleFactor = scale * screen.scale;
    
};

-(void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    VLCMediaPlayerState state = self.mediaPlayer.state;
    switch (state) {
            case VLCMediaPlayerStatePlaying:
        {
            NSLog(@"buffer");
            self.indicatorView.center = self.mediaView.center;
            if(!self.indicatorView.isAnimating){
                //self.indicatorView.alpha = 1.0;
                [self.indicatorView startAnimating];
            }
        }
            
            break;
            case VLCMediaPlayerStateBuffering:
        {NSLog(@"playing");
            if(self.indicatorView.isAnimating){
                //self.indicatorView.alpha = 1.0;
                //self.indicatorView.center = self.mediaView.center;
                [self.indicatorView stopAnimating];
            }
        }
            
            break;
            case VLCMediaPlayerStateOpening:
            NSLog(@"opening");
            break;
            case VLCMediaPlayerStateError:
            [self showMessage:@"错误"];
            break;
            case 0:
            //[self showMessage:@"打开失败"];
            //[self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            NSLog(@"%long",state);
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.playOnStart) {
        [self play];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)play{
    
    if (self.mediaPlayer != nil) {
        if (!self.mediaPlayer.isPlaying) {
            NSURL *mediaUrl = [[NSURL alloc] initWithString:self.urlString];
            if(mediaUrl != nil){
                [self.mediaPlayer setMedia:[[VLCMedia alloc] initWithURL:mediaUrl]];
            }
            else{
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid URL" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                return;
            }
            [self.mediaPlayer play];
        }
    }
}

- (void)stop{
    if (self.mediaPlayer != nil) {
        if (self.mediaPlayer.isPlaying) {
            [self.mediaPlayer stop];
        }
    }
    [[VideoPlayerVLC getInstance] stopInner];
    
    // dismiss view from stack
    [self.view removeFromSuperview];


}

@end

