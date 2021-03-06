//
//  ZXVideoPlayerViewController.m
//  demo
//
//  Created by shaw on 15/7/25.
//  Copyright (c) 2015年 shaw. All rights reserved.
//-----------------播放器vc-----------------------

#import "ZXVideoPlayerViewController.h"
#import "ZXVideoView.h"
#import "ZXCustomControlView.h"
#import <AVFoundation/AVFoundation.h>
#import "XHConst.h"
#import "XHHomeViewController.h"
#import "AFNetWorking.h"
#import "SVProgressHUD.h"
#import "UIView+Extension.h"
#define SCREENWITH   [UIScreen mainScreen].bounds.size.width
#define SCREENHIGH   [UIScreen mainScreen].bounds.size.height

@interface ZXVideoPlayerViewController ()<ZXCustomControlViewDelegate>

@property (nonatomic,strong) AVPlayer *videoPlayer;                         //播放器
@property (nonatomic,strong) ZXVideoView *videoView;                        //播放器显示层
@property (strong) AVPlayerItem *item;

@property (nonatomic,strong) ZXCustomControlView *controlView;              //控件视图

@property (nonatomic,assign) CGRect originFrame;
@property (nonatomic,assign) BOOL isFullscreen;                             //是否横屏
@property (nonatomic,assign) UIInterfaceOrientation currentOrientation;     //当前屏幕方向

@property (nonatomic,strong) id timeObserver;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *certainBtn;
//@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation ZXVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)dealloc
{
    [self removeTimeObserver];
    [self.item removeObserver:self forKeyPath:@"status"];
    [_videoPlayer cancelPendingPrerolls];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

//屏幕方向改变
//-(void)deviceOrientationChanged:(NSNotification *)notification
//{
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
//    
//    if(interfaceOrientation != _currentOrientation)
//    {
//        _currentOrientation = interfaceOrientation;
//        
//        switch (interfaceOrientation) {
//            case UIInterfaceOrientationPortrait:
//            {
//                [self turnToPortraint];
//            }
//                break;
//            case UIInterfaceOrientationPortraitUpsideDown:
//            {
//                [self turnToPortraint];
//            }
//                break;
//            case UIInterfaceOrientationLandscapeLeft:
//            {
//                [self turnToLeft];
//            }
//                break;
//            case UIInterfaceOrientationLandscapeRight:
//            {
//                [self turnToRight];
//            }
//                break;
//            default:
//                break;
//        }
//    }
//}

-(void)setVideoUrl:(NSString *)videoUrl
{
    if(_videoUrl != videoUrl)
    {
        _videoUrl = videoUrl;
        if(_videoUrl == nil)
        {
            return;
        }
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:_videoUrl] options:nil];
        NSArray *requestedKeys = @[@"playable"];
        
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:^{
             dispatch_async(dispatch_get_main_queue(),^{
                [self prepareToPlayAsset:asset withKeys:requestedKeys];
            });
        }];
    }
}

-(void)setup
{
    self.originFrame = self.view.frame;
    
    if(!_controlView)
    {
            ZXCustomControlView *view = [[[NSBundle mainBundle]loadNibNamed:@"ZXCustomControlView" owner:nil options:nil]lastObject];
            view.delegate = self;
            view.backgroundColor = XHGlobalColor;
            view.progress.tintColor = [UIColor whiteColor];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:view];
            self.controlView = view;
            NSDictionary *paramDic = @{@"viewHeight":@(100.0f)};
            NSArray *view_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
            NSArray *view_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(viewHeight)]|" options:0 metrics:paramDic views:NSDictionaryOfVariableBindings(view)];
            [self.view addConstraints:view_H];
            [self.view addConstraints:view_V];
        
        
        __weak ZXVideoPlayerViewController *weakSelf = self;
        [_controlView showWithClickHandle:^(NSInteger tag) {
            switch (tag) {
                case 1:
                {//播放或暂停
                    if(weakSelf.videoPlayer.rate > 0)
                    {
                        weakSelf.controlView.isPlaying = YES;
                        [weakSelf.videoPlayer play];

                                         }
                    else
                    {
                        weakSelf.controlView.isPlaying = NO;
                        [weakSelf.videoPlayer pause];
                 }
                }
                    break;
                default:
                    break;
            }
        } slideHandle:^(CGFloat interval,BOOL isFinished) {
            if(isFinished)
            {
                //滑块拖动停止
                CMTime time = CMTimeMakeWithSeconds(interval, weakSelf.videoPlayer.currentItem.duration.timescale);
                [weakSelf.videoPlayer seekToTime:time completionHandler:^(BOOL finished) {
                    [weakSelf.videoPlayer play];
                    weakSelf.controlView.isPlaying = YES;
                }];
            }
            else
            {
                if(weakSelf.videoPlayer.rate > 0)
                {
                    weakSelf.controlView.isPlaying = NO;
                    [weakSelf.videoPlayer pause];
                }
            }
        }];
    }
    
    //添加屏幕单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

/////////////////////////////////
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    for (NSString *thisKey in requestedKeys)
    {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed)
        {
            [self assetFailedToPrepareForPlayback:error];
            return;
        }
    }
    
    if (!asset.playable)
    {
        NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localizedDescription, NSLocalizedDescriptionKey,
                                   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
                                   nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
    
    if (self.item)
    {
        [self.item removeObserver:self forKeyPath:@"status"];
    }
    
    self.item = [AVPlayerItem playerItemWithAsset:asset];
    
    [self.item addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:nil];
    
    if (!self.videoPlayer)
    {
        self.videoPlayer = [AVPlayer playerWithPlayerItem:self.item];
    }
    
    if (self.videoPlayer.currentItem != self.item)
    {
        [self.videoPlayer replaceCurrentItemWithPlayerItem:self.item];
    }
    
    [self removeTimeObserver];
    
    __weak ZXVideoPlayerViewController *weakSelf = self;
    self.timeObserver = [_videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);

        [weakSelf.controlView setSlideValue:currentTime / weakSelf.controlView.videoDuration];
    }];
    
    if(!_videoView)
    {
        self.videoView = [[ZXVideoView alloc]initWithFrame:self.view.bounds];
        _videoView.translatesAutoresizingMaskIntoConstraints = NO;
        _videoView.player = _videoPlayer;
        [_videoView setFillMode:AVLayerVideoGravityResizeAspect];
        [self.view insertSubview:_videoView belowSubview:_controlView];
        
        NSArray *view_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_videoView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_videoView)];
        NSArray *view_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_videoView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_videoView)];
        [self.view addConstraints:view_H];
        [self.view addConstraints:view_V];
    }
    [self.view sendSubviewToBack:_videoView];
    
//    [_videoPlayer play];
}

-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                        message:[error localizedFailureReason]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)removeTimeObserver
{
    if (_timeObserver)
    {
        [self.videoPlayer removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self.view];
    if(!CGRectContainsPoint(_controlView.frame, point))
    {
        [_controlView setHidden:!_controlView.isHidden];
        [_cancelBtn setHidden:!_cancelBtn.isHidden];
        [_certainBtn setHidden:!_certainBtn.isHidden];
    }
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
-(void)turnToPortraint
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.transform = CGAffineTransformIdentity;
        self.view.frame = _originFrame;
    }completion:^(BOOL finished) {
        self.isFullscreen = NO;
    }];
}

-(void)turnToLeft
{
    CGRect frect = [self getLandscapeFrame];
    
    //横屏旋转的时候 需要先置为初始状态，否则会出现位置偏移的情况
    if(_isFullscreen)
    {
        self.view.transform = CGAffineTransformIdentity;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = frect;
        self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }completion:^(BOOL finished) {
        self.isFullscreen = YES;
    }];
}

-(void)turnToRight
{
    CGRect frect = [self getLandscapeFrame];
    
    if(_isFullscreen)
    {
        self.view.transform = CGAffineTransformIdentity;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = frect;
        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    }completion:^(BOOL finished) {
        self.isFullscreen = YES;
    }];
}

-(CGRect)getLandscapeFrame
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGRect frect = CGRectZero;
    frect.origin.x = (screenSize.width - screenSize.height) / 2.0f;
    frect.origin.y = (screenSize.height - screenSize.width) / 2.0f;
    frect.size.width = screenSize.height;
    frect.size.height = screenSize.width;
    
    return frect;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"status"])
    {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        
        switch (status) {
            case AVPlayerStatusReadyToPlay:
            {   
                [_controlView setIsPlaying:YES];
                [_controlView setIsControlEnable:YES];
                
                //只有在播放状态才能获取视频时间长度
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                NSTimeInterval duration = CMTimeGetSeconds(playerItem.asset.duration);
                _controlView.videoDuration = duration;
            }
                break;
            case AVPlayerStatusFailed:
            {
                [_controlView setIsPlaying:NO];
                
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
            case AVPlayerStatusUnknown:
            {
                [_controlView setIsPlaying:NO];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark  - ZXCustomControlViewDelegate

//取消（不上传）
- (void)customControlViewCancelButtonDidClick:(ZXCustomControlView *)customView
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];

}
//上传
- (void)customControlViewUploadButtonDidClick:(ZXCustomControlView *)customView
{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,XHAttachmentUrl];
    
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.data name:@"attachment" fileName:@"att.jpg" mimeType:@"image/jpeg"];
    } error:nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        if ([self.delegate respondsToSelector:@selector(ZXVideoPlayerViewControllerSureButtonDidClick:carryFileName:)]) {
            [self.delegate ZXVideoPlayerViewControllerSureButtonDidClick:self carryFileName:responseObject[@"tempFilename"]];
                                         }
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [SVProgressHUD showErrorWithStatus:@"上传失败"];
                                     }];
     [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss" object:self];
        }];
         double f = (double)totalBytesWritten / totalBytesExpectedToWrite;
         [SVProgressHUD showProgress:f status:@"上传中" maskType:SVProgressHUDMaskTypeBlack];
    }];
    
    [operation start];
}
// 播放
- (void)customControlViewPlayButtonDidClick:(ZXCustomControlView *)customView isSelected:(BOOL)selected
{
    
    if (selected) {
        
        [_videoPlayer play];
        [_controlView setIsPlaying:YES];

    }else{
        [_videoPlayer pause];
        [_controlView setIsPlaying:NO];
    }

}
@end
