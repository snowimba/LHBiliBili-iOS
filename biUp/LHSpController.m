//
//  LHSpController.m
//  biUp
//
//  Created by snowimba on 15/12/24.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHBtnBar.h"
#import "LHParam.h"
#import "LHShop.h"
#import "LHSpController.h"
#import "LHSpScrollView.h"
#import "LHWebAVPlayer.h"
#import "MoviePlayerViewController.h"
#import "UIImageView+WebCache.h"
@interface LHSpController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView* icon;
@property (weak, nonatomic) IBOutlet UILabel* name;
@property (weak, nonatomic) IBOutlet UILabel* play;
@property (weak, nonatomic) IBOutlet UILabel* danmu;

@property (weak, nonatomic) IBOutlet UILabel* timeLink;
@property (weak, nonatomic) IBOutlet UILabel* avNum;
@property (nonatomic, strong) NSArray* arrDict;
@property (weak, nonatomic) IBOutlet UIView* topView;
@property (weak, nonatomic) IBOutlet UIView* senView;
@property (weak, nonatomic) IBOutlet LHBtnBar* btnBar;
@property (nonatomic, assign) CGFloat lastY;
@property (weak, nonatomic) IBOutlet LHSpScrollView* spScrollView;

@end

@implementation LHSpController
- (IBAction)popBtn:(UIButton*)sender
{

    [self.navigationController popViewControllerAnimated:YES];
}
- (NSArray*)arrDict
{

    if (!_arrDict) {
        _arrDict = [NSArray arrayWithObjects:@"承包商排行", @"番剧详情", @"评论", nil];
    }

    return _arrDict;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.cellM.cover]];
    self.name.text = self.cellM.title;
    self.play.text = [NSString stringWithFormat:@"%@", self.cellM.play_count > 10000 ? [NSString stringWithFormat:@"%0.1f万", (self.cellM.play_count / 10000.0)] : [NSString stringWithFormat:@"%zd", self.cellM.play_count]];

    self.danmu.text = [NSString stringWithFormat:@"%@", self.cellM.danmaku_count > 10000 ? [NSString stringWithFormat:@"%0.1f万", (self.cellM.danmaku_count / 10000.0)] : [NSString stringWithFormat:@"%zd", self.cellM.danmaku_count]];
    if (self.cellM.is_finish == 0) {
        self.timeLink.text = [NSString stringWithFormat:@"连载中,每周%zd更新", self.cellM.weekday];
    }
    else {

        self.timeLink.text = @"完结";
    }

    self.spScrollView.delegate = self;

    self.spScrollView.cellM = self.cellM;

    self.btnBar.titleArr = self.arrDict;

    __weak typeof(self) weakSelf = self;

    self.btnBar.clickBtn = ^(NSInteger tag) {

        weakSelf.spScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * (tag - 1), 0);

    };

    self.spScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    [self scrollViewDidScroll:self.spScrollView];
    [self scrollViewDidEndDecelerating:self.spScrollView];

    [self.view bringSubviewToFront:self.topView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveSpTopBarDid:) name:@"moveSpTopBar" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerSpAV:) name:@"playerSpAV" object:nil];
}

- (void)playerSpAV:(NSNotification*)note
{

    self.view.userInteractionEnabled = NO;
    LHParam* param = note.object;

    LHWebAVPlayer* avP = [[LHWebAVPlayer alloc] init];

    MoviePlayerViewController* movie = [[MoviePlayerViewController alloc] init];

    __weak typeof(movie) weakMovie = movie;
    __weak typeof(self) weakSelf = self;
    
    avP.AVPlayer = ^(NSArray* url) {

        NSString* urlString = [url firstObject];

        //            NSURL* URL = [NSURL URLWithString:urlString];
        weakMovie.url = urlString;
        weakMovie.danmaku = param.danmaku;

        if (urlString.length) {

            if (weakSelf.presentedViewController == nil) {

                [weakSelf presentViewController:movie animated:NO completion:nil];
            }
            //        [weakSelf presentViewController:movie animated:NO completion:nil];
        }else{
        
            self.view.userInteractionEnabled = YES;
        
        }
    };
    
     avP.param = param.param;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //    self.spScrollView.alpha = 1;
    //    self.spScrollView.hidden = NO;
    //    [self.view addSubview:self.spScrollView];
    self.view.userInteractionEnabled = YES;
}

- (void)moveSpTopBarDid:(NSNotification*)note
{
    CGFloat moveY = [note.object floatValue];

    CGFloat moveRY = moveY - self.lastY;

    if (self.btnBar.transform.ty - moveRY >= -160 && self.btnBar.transform.ty - moveRY <= 0) {

        self.btnBar.transform = CGAffineTransformTranslate(self.btnBar.transform, 0, -moveRY);
        self.senView.transform = CGAffineTransformTranslate(self.btnBar.transform, 0, -moveRY);

        self.spScrollView.transform = CGAffineTransformTranslate(self.spScrollView.transform, 0, -moveRY);
    }
    else if (self.btnBar.transform.ty - moveRY < -160) {

        self.btnBar.transform = CGAffineTransformMakeTranslation(0, -160);

        self.senView.transform = CGAffineTransformMakeTranslation(0, -160);

        self.spScrollView.transform = CGAffineTransformMakeTranslation(0, -160);
    }
    else if (self.btnBar.transform.ty - moveRY > 0) {

        self.btnBar.transform = CGAffineTransformMakeTranslation(0, 0);

        self.senView.transform = CGAffineTransformMakeTranslation(0, 0);

        self.spScrollView.transform = CGAffineTransformMakeTranslation(0, 0);
    }

    self.lastY = moveY;
}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 @property (nonatomic,copy) NSString *cover;
 @property (nonatomic,copy) NSString *title;
 @property (nonatomic,assign) NSInteger play_count;
 @property (nonatomic,assign) NSInteger danmaku_count;
 @property (nonatomic,assign) NSInteger season_id;
 @property (nonatomic,assign) NSInteger weekday;
 @property (nonatomic,copy) NSString *bgmcount;
 @property (nonatomic,assign) NSInteger is_finish;
 */

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    self.btnBar.bottomView.transform = CGAffineTransformMakeTranslation(scrollView.contentOffset.x / 5, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    NSUInteger tagNum = (scrollView.contentOffset.x + [UIScreen mainScreen].bounds.size.width * 0.5) / [UIScreen mainScreen].bounds.size.width + 1;
    [self.btnBar changeBtnColor:tagNum];
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
