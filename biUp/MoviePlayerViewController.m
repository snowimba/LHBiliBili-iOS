//
//  MoviePlayerViewController.m
//  Player
//
//  Created by dllo on 15/11/7.
//  Copyright © 2015年 zhaoqingwen. All rights reserved.
//

#import "AFNetworking.h"
#import "CFDanmakuView.h"
#import "DanMuModel.h"
#import "LHWebAVPlayer.h"
#import "MoviePlayerViewController.h"
#import "UIKit+AFNetworking.h"
#import "XML2Dic.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)(((rgbValue)&0xFF0000) >> 16)) / 255.0 green:((float)(((rgbValue)&0xFF00) >> 8)) / 255.0 blue:((float)((rgbValue)&0xFF)) / 255.0 alpha:1.0]

@interface MoviePlayerViewController () <CFDanmakuDelegate>
@property (nonatomic, weak) CFDanmakuView* danmakuView;
@property (nonatomic, strong) AVPlayer* player; // 播放属性
@property (nonatomic, strong) AVPlayerItem* playerItem; // 播放属性
@property (nonatomic, assign) CGFloat width; // 坐标
@property (nonatomic, assign) CGFloat height; // 坐标
@property (nonatomic, weak) UISlider* slider; // 进度条
@property (nonatomic, weak) UILabel* currentTimeLabel; // 当前播放时间
@property (nonatomic, weak) UILabel* systemTimeLabel; // 系统时间
@property (nonatomic, weak) UIView* backView; // 上面一层Viewd
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat systemVolume;
@property (nonatomic, weak) UISlider* volumeViewSlider;
@property (nonatomic, weak) UIActivityIndicatorView* activity; // 系统菊花
@property (nonatomic, weak) UIProgressView* progress; // 缓冲条
@property (nonatomic, weak) UIView* topView;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, assign) double lastTime;
//@property (nonatomic, assign) NSInteger count_danmu;
@property (nonatomic, copy) NSString* path;
@property (nonatomic, strong) AVPlayerLayer* layerAV;
@end

@implementation MoviePlayerViewController

- (void)dealloc
{
    //            NSLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    self.player = nil;
    //    loadedTimeRanges
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    _width = [[UIScreen mainScreen] bounds].size.height;
    _height = [[UIScreen mainScreen] bounds].size.width;
    // 创建AVPlayer
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.url]];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.layerAV = [AVPlayerLayer playerLayerWithPlayer:_player];

    self.layerAV.frame = CGRectMake(0, 0, _width, _height);
    self.layerAV.videoGravity = AVLayerVideoGravityResize;

    [self.view.layer addSublayer:self.layerAV];
    [_player play];
    //AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];

    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
    self.backView = backView;
    [self.view addSubview:_backView];
    _backView.backgroundColor = [UIColor clearColor];

    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, 44)];
    self.topView = topView;
    _topView.backgroundColor = [UIColor blackColor];
    _topView.alpha = 0.5;
    [_backView addSubview:_topView];

    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil]; // 监听loadedTimeRanges属性

    [self createProgress];
    [self createSlider];
    [self createCurrentTimeLabel];
    [self createButton];
    [self backButton];
    [self createTitle];
    [self createGesture];

    [self customVideoSlider];

    UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activity = activity;
    _activity.center = _backView.center;
    [self.view addSubview:_activity];
    [_activity startAnimating];

    //    //延迟线程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [UIView animateWithDuration:0.5 animations:^{

            _backView.alpha = 0;
        }];

    });

    //计时器
    //    [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(Stack) userInfo:nil repeats:YES];
    [self timer];

    //    self.modalPresentationCapturesStatusBarAppearance = YES;
}

//---------------danmu
#pragma mark - 弹幕代码

- (NSTimer*)timer
{

    if (!_timer) {

        NSTimer* t = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(Stack) userInfo:nil repeats:YES];
        _timer = t;
    }

    return _timer;
}

- (void)setupDanmakuView
{
    CGRect rect = CGRectMake(0, 2, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width - 44);
    CFDanmakuView* danmakuView = [[CFDanmakuView alloc] initWithFrame:rect];
    self.danmakuView = danmakuView;
    _danmakuView.duration = 6.5;
    _danmakuView.centerDuration = 2.5;
    _danmakuView.lineHeight = 25;
    _danmakuView.maxShowLineCount = 15;
    _danmakuView.maxCenterLineCount = 5;
    _danmakuView.delegate = self;
    _danmakuView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_danmakuView];
    [self.view bringSubviewToFront:_danmakuView];
    //    [self.view bringSubviewToFront:self.topView];
}

- (void)setDanmaku:(NSString*)danmaku
{

    _danmaku = danmaku;

    if (!_danmakuView) {

        [self setupDanmakuView];
    }
    self.path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", danmaku]];

    if ([NSKeyedUnarchiver unarchiveObjectWithFile:self.path]) {

        NSFileManager* fm = [NSFileManager defaultManager];
        NSDictionary* attr = [fm attributesOfItemAtPath:self.path error:nil];
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSMutableString* timeS = [NSMutableString stringWithFormat:@"%@", [attr valueForKey:@"NSFileCreationDate"]];
        for (NSInteger i = 0; i < timeS.length; i++) {
            if ([timeS characterAtIndex:i] == '+') {

                [timeS deleteCharactersInRange:NSMakeRange(i, timeS.length - i)];
                break;
            }
        }
        NSDate* date1 = [df dateFromString:timeS];
        NSTimeInterval timeI = [date1 timeIntervalSinceNow];
        NSInteger hour = timeI / 3600 + 8;

        if (hour >= 12) {

            [fm removeItemAtPath:self.path error:nil];
            NSLog(@"弹幕过期删除重载");
            [self getTheDanModle];
        }
        else {

            NSMutableArray* arrM = [NSKeyedUnarchiver unarchiveObjectWithFile:self.path];

            [_danmakuView prepareDanmakus:arrM];

            if (_danmakuView.isPrepared) {

                [_danmakuView start];
            }
        }
    }
    else {

        [self getTheDanModle];
    }
}

- (void)getTheDanModle
{

    [_danmakuView clear];

    //    NSLog(@"web");
    NSURL* URLD = [NSURL URLWithString:[NSString stringWithFormat:@"http://comment.bilibili.com/%@.xml", self.danmaku]];
    ////http://comment.bilibili.com/5469241.xml
    //        NSLog(@"%@",URLD);
    NSURLRequest* reqD = [NSURLRequest requestWithURL:URLD];

    UIWebView* webD = [[UIWebView alloc] init];
    NSProgress* progress = nil;
    [webD loadRequest:reqD progress:&progress success:^NSString* _Nonnull(NSHTTPURLResponse* _Nonnull response, NSString* _Nonnull HTML) {

        if (HTML != nil) {

            NSDictionary* dict = [XML2Dic dicWithData:HTML];

            [self setupDanmakuData:dict];
        }
        return HTML;
    }

        failure:^(NSError* _Nonnull error){
        }];
}

- (void)setupDanmakuData:(NSDictionary*)dict
{

    //    NSLog(@"%@", dict);

    //    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:self.dict];

    NSMutableArray* danmakus = [NSMutableArray array];
    [dict enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL* _Nonnull stop) {
        for (DanMuModel* danmu in obj) {

            CFDanmaku* danmaku = [[CFDanmaku alloc] init];
            NSMutableAttributedString* contentStr = [[NSMutableAttributedString alloc] initWithString:danmu.text.length > 0 ? danmu.text : @"2333" attributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:danmu.fontSize ? [danmu.fontSize floatValue] : 14.0],
                NSForegroundColorAttributeName : UIColorFromRGB(danmu.textColor ? ((long)[danmu.textColor doubleValue]) : 0xffffff) }];
            //            NSMutableAttributedString* contentStr = [[NSMutableAttributedString alloc] initWithString:danmu.text ? danmu.text : @"" attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName : [UIColor whiteColor] }];

            danmaku.contentStr = contentStr;

            if ([danmu.sendTime doubleValue] <= 0.5) {
                danmaku.timePoint = 0.6;
            }
            else {

                danmaku.timePoint = [danmu.sendTime doubleValue] ? [danmu.sendTime doubleValue] : 0.6;
            }

            //                NSLog(@"%f",danmaku.timePoint);
            danmaku.position = ([danmu.style integerValue] - 1) % 3;

            [danmakus addObject:danmaku];
        }

        //        NSLog(@"%@",danmakus);

    }];

    if (danmakus.count) {

        [NSKeyedArchiver archiveRootObject:danmakus toFile:self.path];
    }

    [_danmakuView prepareDanmakus:danmakus];

    if (_danmakuView.isPrepared) {
        [_danmakuView start];
    }
}

#pragma mark - 弹幕代理
- (NSTimeInterval)danmakuViewGetPlayTime:(CFDanmakuView*)danmakuView
{

    if (_playerItem.duration.timescale == 0) {
        return 0;
    }
    else {

        if ((double)(_slider.value * (_playerItem.duration.value / _playerItem.duration.timescale)) == self.lastTime) {
            [_danmakuView pause];
            return 0;
        }
        else {

            [_danmakuView resume];
            self.lastTime = (double)(_slider.value * (_playerItem.duration.value / _playerItem.duration.timescale));
            return (double)(_slider.value * (_playerItem.duration.value / _playerItem.duration.timescale));
        }
        //        NSLog(@"%f", (_slider.value * (_playerItem.duration.value / _playerItem.duration.timescale)));
        //http://comment.bilibili.com/5469241.xml
    }
}

- (BOOL)danmakuViewIsBuffering:(CFDanmakuView*)danmakuView
{
    return NO;
}

//---------------------------------------

#pragma mark - 横屏代码
- (BOOL)shouldAutorotate
{
    return NO;
} //NS_AVAILABLE_IOS(6_0);当前viewcontroller是否支持转屏

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{

    return UIInterfaceOrientationMaskLandscape;
} //当前viewcontroller支持哪些转屏方向

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden
{
    return NO; // 返回NO表示要显示，返回YES将hiden
}
#pragma mark - 创建UISlider
- (void)createSlider
{
    UISlider* slider = [[UISlider alloc] initWithFrame:CGRectMake(100, 345, _width * 0.7, 15)];
    self.slider = slider;
    [self.backView addSubview:_slider];
    [_slider setThumbImage:[UIImage imageNamed:@"iconfont-yuan.png"] forState:UIControlStateNormal];
    [_slider addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
    _slider.minimumTrackTintColor = [UIColor colorWithRed:30 / 255.0 green:80 / 255.0 blue:100 / 255.0 alpha:1];
}

#pragma mark - slider滑动事件
- (void)progressSlider:(UISlider*)slider
{
    //拖动改变视频播放进度
    if (_player.status == AVPlayerStatusReadyToPlay) {

        //    //计算出拖动的当前秒数
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;

        //    NSLog(@"%f", total);

        NSInteger dragedSeconds = floorf(total * slider.value);

        //    NSLog(@"dragedSeconds:%ld",dragedSeconds);

        //转换成CMTime才能给player来控制播放进度

        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);

        [_player pause];

        [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish) {

            [_player play];

        }];
    }
}
#pragma mark - 创建UIProgressView
- (void)createProgress
{
    UIProgressView* progress = [[UIProgressView alloc] initWithFrame:CGRectMake(102, 352, _width * 0.69, 15)];
    self.progress = progress;
    [_backView addSubview:_progress];
}
#pragma mark -
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration]; // 计算缓冲进度
        //        NSLog(@"Time Interval:%f",timeInterval);
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.progress setProgress:timeInterval / totalDuration animated:NO];
    }
}

- (NSTimeInterval)availableDuration
{
    NSArray* loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue]; // 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds; // 计算缓冲总进度
    return result;
}
- (void)customVideoSlider
{
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage* transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //    [self.slider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}

#pragma mark - 创建播放时间
- (void)createCurrentTimeLabel
{
    UILabel* currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_width * 0.86, 342, 100, 20)];
    self.currentTimeLabel = currentTimeLabel;
    [self.backView addSubview:_currentTimeLabel];
    _currentTimeLabel.textColor = [UIColor whiteColor];
    //    _currentTimeLabel.backgroundColor = [UIColor blueColor];
    _currentTimeLabel.font = [UIFont systemFontOfSize:12];
    _currentTimeLabel.text = @"00:00/00:00";
}
#pragma mark - 计时器事件
- (void)Stack
{

    if (_playerItem.duration.timescale != 0) {

        _slider.maximumValue = 1; //音乐总共时长
        _slider.value = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale); //当前进度

        //        NSLog(@"%f", CMTimeGetSeconds([_playerItem currentTime]));
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60; //当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60; //当前分钟
        //    NSLog(@"%d",_playerItem.duration.timescale);
        //    NSLog(@"%lld",_playerItem.duration.value/1000 / 60);

        //duration 总时长

        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60; //总秒
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60; //总分钟
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", (long)proMin, proSec, durMin, durSec];

        //        if (_danmakuView.isPrepared) {
        //            [_danmakuView start];
        //        }

        if (_danmakuView != nil && ![_danmakuView isPlaying] && ((NSInteger)CMTimeGetSeconds([_playerItem currentTime]) % 5) == 2) {

            if ([NSKeyedUnarchiver unarchiveObjectWithFile:self.path]) {

                [_danmakuView clear];

                NSMutableArray* arrM = [NSKeyedUnarchiver unarchiveObjectWithFile:self.path];

                [_danmakuView prepareDanmakus:arrM];
            }

            [_danmakuView start];
        }
    }
    if (_player.status == AVPlayerStatusReadyToPlay) {
        [_activity stopAnimating];
    }
    else {
        [_activity startAnimating];
    }
}
#pragma mark - 播放和下一首按钮
- (void)createButton
{
    UIButton* startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(15, 337, 30, 30);
    [self.backView addSubview:startButton];
    if (_player.rate == 1.0) {

        [startButton setBackgroundImage:[UIImage imageNamed:@"pauseBtn@2x.png"] forState:UIControlStateNormal];
    }
    else {
        [startButton setBackgroundImage:[UIImage imageNamed:@"playBtn@2x.png"] forState:UIControlStateNormal];
    }
    [startButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];

    UIButton* nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(60, 340, 25, 25);
    [self.backView addSubview:nextButton];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"nextPlayer@3x.png"] forState:UIControlStateNormal];
}
#pragma mark - 播放暂停按钮方法
- (void)startAction:(UIButton*)button
{
    if (button.selected) {
        [_player play];
        [button setBackgroundImage:[UIImage imageNamed:@"pauseBtn@2x.png"] forState:UIControlStateNormal];
        [_danmakuView resume];
    }
    else {
        [_player pause];
        [button setBackgroundImage:[UIImage imageNamed:@"playBtn@2x.png"] forState:UIControlStateNormal];
        [_danmakuView pause];
    }
    button.selected = !button.selected;
}
#pragma mark - 返回按钮方法
- (void)backButton
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, 7, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"iconfont-back.png"] forState:UIControlStateNormal];
    [_topView addSubview:button];

    [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 创建标题
- (void)createTitle
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 250, 30)];
    [_backView addSubview:label];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
}
#pragma mark - 创建手势
- (void)createGesture
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];

    //获取系统音量
    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView* view in [volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            _volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    _systemVolume = _volumeViewSlider.value;
}
#pragma mark - 轻拍方法
- (void)tapAction:(UITapGestureRecognizer*)tap
{
    if (_backView.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{

            _backView.alpha = 0;
        }];
    }
    else if (_backView.alpha == 0) {
        [UIView animateWithDuration:0.5 animations:^{

            _backView.alpha = 1;
        }];
    }
    if (_backView.alpha == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [UIView animateWithDuration:0.5 animations:^{

                _backView.alpha = 0;
            }];

        });
    }
}
#pragma mark - 滑动调整音量大小
- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    if (event.allTouches.count == 1) {
        //保存当前触摸的位置
        CGPoint point = [[touches anyObject] locationInView:self.view];
        _startPoint = point;
    }
}
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{

    if (event.allTouches.count == 1) {
        //计算位移
        CGPoint point = [[touches anyObject] locationInView:self.view];
        //        float dx = point.x - startPoint.x;
        float dy = point.y - _startPoint.y;
        int index = (int)dy;
        if (index > 0) {
            if (index % 5 == 0) { //每10个像素声音减一格
                //                NSLog(@"%.2f",_systemVolume);
                if (_systemVolume > 0.1) {
                    _systemVolume = _systemVolume - 0.05;
                    [_volumeViewSlider setValue:_systemVolume animated:YES];
                    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        else {
            if (index % 5 == 0) { //每10个像素声音增加一格
                //                NSLog(@"+x ==%d",index);
                NSLog(@"%.2f", _systemVolume);
                if (_systemVolume >= 0 && _systemVolume < 1) {
                    _systemVolume = _systemVolume + 0.05;
                    [_volumeViewSlider setValue:_systemVolume animated:YES];
                    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        //亮度调节
        //        [UIScreen mainScreen].brightness = (float) dx/self.view.bounds.size.width;
    }
}

- (void)moviePlayDidEnd:(id)sender
{
    //    [_player pause];
    //    [self.timer invalidate];
    [_danmakuView stop];

    [_danmakuView removeFromSuperview];

    _danmakuView = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    self.player = nil;
    self.playerItem = nil;

    [self.view.layer removeAllAnimations];

    [self.layerAV removeAllAnimations];

    [self.layerAV removeFromSuperlayer];

    [self.timer invalidate];

    [self dismissViewControllerAnimated:NO completion:^{

    }];
}
- (void)backButtonAction
{
    [_player pause];

    //    [self.timer invalidate];

    [_danmakuView stop];

    //    [_danmakuView cl]

    [_danmakuView removeFromSuperview];

    _danmakuView = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    self.player = nil;
    self.playerItem = nil;

    [self.view.layer removeAllAnimations];
    //    [self.view.layer removeFromSuperlayer];

    [self.layerAV removeAllAnimations];

    [self.layerAV removeFromSuperlayer];

    [self.timer invalidate];

    [self dismissViewControllerAnimated:NO completion:^{

    }];
}

- (void)didReceiveMemoryWarning
{
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

@end
