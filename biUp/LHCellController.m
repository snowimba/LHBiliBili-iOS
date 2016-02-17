//
//  LHCellController.m
//  biUp
//
//  Created by snowimba on 15/12/12.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHBtnBar.h"
#import "LHCellController.h"
#import "LHCellScroll.h"
#import "LHDescModel.h"
#import "LHDownLoadController.h"
#import "LHDownView.h"
#import "LHSearchController.h"
#import "LHSearchView.h"
#import "LHSortAV.h"
#import "LHTaCellM.h"
#import "LHWebAVPlayer.h"
#import "MoviePlayerViewController.h"
#import "NSString+Tools.h"
#import "UIImageView+WebCache.h"
#define PATH_CELL [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"collection_cell.data"]

#define PATH_HIS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"his_cell.data"]
@interface LHCellController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView* topView;
@property (weak, nonatomic) IBOutlet UIView* moveView;
@property (weak, nonatomic) IBOutlet UILabel* avNumLbl;
@property (weak, nonatomic) IBOutlet UIImageView* smallCover;
@property (weak, nonatomic) IBOutlet UILabel* titleLbl;

@property (weak, nonatomic) IBOutlet UIButton* upLbl;

@property (weak, nonatomic) IBOutlet UILabel* danmuLbl;
@property (weak, nonatomic) IBOutlet LHBtnBar* btnBar;
@property (weak, nonatomic) IBOutlet LHCellScroll* cellScroll;
@property (nonatomic, assign) CGFloat lastY;
@property (nonatomic, strong) NSArray* arrDict;
@property (nonatomic, strong) NSMutableDictionary* dictM;
@property (nonatomic, strong) NSMutableDictionary* dictMHis;
@property (weak, nonatomic) IBOutlet UIButton* collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton* downLoadBtn;
@property (nonatomic, strong) LHDownView* downView;
@property (nonatomic, strong) NSMutableArray* sortAVs;
@end

@implementation LHCellController
- (IBAction)upBtnAction:(UIButton*)sender
{

    NSString* strM = [NSString stringWithFormat:@"%@", sender.titleLabel.text];
    
    
    strM = [strM substringFromIndex:3];
    
    

    LHSearchController* seaC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];

    seaC.keyWord = strM;

    [self.navigationController pushViewController:seaC animated:YES];
}

- (NSMutableDictionary*)dictM
{

    if (!_dictM) {
        _dictM = [NSMutableDictionary dictionary];
    }
    return _dictM;
}

- (NSMutableDictionary*)dictMHis
{

    if (!_dictMHis) {
        _dictMHis = [NSMutableDictionary dictionary];
    }
    return _dictMHis;
}

- (NSMutableArray*)sortAVs
{

    if (!_sortAVs) {

        _sortAVs = [NSMutableArray array];

        [LHWebAVPlayer getDownLoadURLToSortAV:[self.cellM param] backBlock:^(NSArray* arr, NSString* desc, NSString* up) {

            [_sortAVs addObject:arr];
            if (desc.length > 0) {

                [_sortAVs addObject:desc];
            }
            else {

                [_sortAVs addObject:@""];
            }

            if (up.length > 0 && self.upLbl.titleLabel.text.length == 0) {

                //                self.upLbl.text =[NSString stringWithFormat:@"UP主:%@",up];

                [self.upLbl setTitle:[NSString stringWithFormat:@"UP:%@", up] forState:UIControlStateNormal];
            }
            self.cellScroll.sortAVs = self.sortAVs;
            self.cellScroll.cellM = self.cellM;
        }];
    }

    return _sortAVs;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    self.view.userInteractionEnabled = YES;
    if (_downView) {
        _downView.cellM = self.cellM;
        _downView.arrDict = [self.sortAVs firstObject];
    }
}

- (IBAction)downLoad:(UIButton*)sender
{

    if (!_downView) {

        _downView = [LHDownView downLoadView];
    }

    __weak typeof(self) weakSelf = self;

    self.downView.pushBlock = ^() {

        LHDownLoadController* VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DownLoad"];

        [weakSelf.navigationController pushViewController:VC animated:YES];
    };
    self.downView.cellM = self.cellM;
    
    self.downView.arrDict = [self.sortAVs firstObject];

    self.downView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.btnBar.frame));
    [self.view addSubview:self.downView];

    [self.view bringSubviewToFront:self.downView];

    [UIView animateWithDuration:0.5 animations:^{

        self.downView.transform = CGAffineTransformMakeTranslation(0, -self.downView.bounds.size.height);
    }];
}

- (IBAction)collectionBtn:(UIButton*)sender
{

    if (sender.isSelected) {

        self.collectionBtn.selected = NO;

        [self.dictM removeObjectForKey:[self.cellM param]];
    }
    else {

        self.collectionBtn.selected = YES;

        NSDate* date = [NSDate date];

        NSDateFormatter* df = [[NSDateFormatter alloc] init];

        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";

        NSString* dtaeStr = [df stringFromDate:date];

        [self.cellM setCollTime:dtaeStr];

        [self.dictM setValue:self.cellM forKey:[self.cellM param]];
    }

    [NSKeyedArchiver archiveRootObject:self.dictM toFile:PATH_CELL];
}
- (IBAction)searchBtn:(id)sender
{

    LHSearchView* searchView = [LHSearchView searchView];

    searchView.frame = self.view.bounds;

    searchView.alpha = 0;

    [self.view addSubview:searchView];

    [UIView animateWithDuration:0.25 animations:^{

        searchView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

        searchView.alpha = 1;

        [self.view bringSubviewToFront:searchView];

    }];
    __weak typeof(self) weakSelf = self;
    searchView.searchBlock = ^(NSString* key) {

        LHSearchController* seaC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"search"];

        seaC.keyWord = key;

        [weakSelf.navigationController pushViewController:seaC animated:YES];

    };
}

- (NSArray*)arrDict
{

    if (!_arrDict) {
        _arrDict = [NSArray arrayWithObjects:@"视频详情", @"相关视频", @"评论", nil];
    }

    return _arrDict;
}

//- (IBAction)playBtn:(id)sender
//{
//    self.view.userInteractionEnabled = NO;
//
//    if ([NSKeyedUnarchiver unarchiveObjectWithFile:PATH_HIS]) {
//        self.dictMHis = [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_HIS];
//        if ([self.dictMHis valueForKey:[self.cellM param]]) {
//
//            NSDate* date = [NSDate date];
//
//            NSDateFormatter* df = [[NSDateFormatter alloc] init];
//
//            df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//
//            NSString* dtaeStr = [df stringFromDate:date];
//
//            [self.cellM setHisTime:dtaeStr];
//
//            [self.dictMHis removeObjectForKey:[self.cellM param]];
//
//            [self.dictMHis setValue:self.cellM forKey:[self.cellM param]];
//
//            [NSKeyedArchiver archiveRootObject:self.dictMHis toFile:PATH_HIS];
//        }
//        else {
//
//            NSDate* date = [NSDate date];
//
//            NSDateFormatter* df = [[NSDateFormatter alloc] init];
//
//            df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//
//            NSString* dtaeStr = [df stringFromDate:date];
//
//            [self.cellM setHisTime:dtaeStr];
//
//            [self.dictMHis setValue:self.cellM forKey:[self.cellM param]];
//
//            [NSKeyedArchiver archiveRootObject:self.dictMHis toFile:PATH_HIS];
//        }
//    }
//
//    LHWebAVPlayer* avP = [[LHWebAVPlayer alloc] init];
//
//    MoviePlayerViewController* movie = [[MoviePlayerViewController alloc] init];
//
//    __weak typeof(movie) weakMovie = movie;
//    __weak typeof(self) weakSelf = self;
//
//    avP.AVPlayer = ^(NSArray* url) {
//
//        NSString* urlString = [url firstObject];
//
//        //            NSURL* URL = [NSURL URLWithString:urlString];
//
//        weakMovie.url = urlString;
//
//        weakMovie.danmaku = [url lastObject];
//
//        if (urlString.length) {
//
//            if (weakSelf.presentedViewController == nil) {
//
//                [weakSelf presentViewController:movie animated:NO completion:nil];
//            }
//        }
//        else {
//
//            self.view.userInteractionEnabled = YES;
//        }
//
//    };
//
//    avP.param = [self.cellM param];
//}

- (IBAction)backBtn:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.cellM setRand:arc4random_uniform(100000)];

    self.avNumLbl.text = [NSString stringWithFormat:@"av%@", [self.cellM param]];
    [self.smallCover sd_setImageWithURL:[NSURL URLWithString:[self.cellM small_cover]]];
    self.titleLbl.text = [self.cellM title];

    NSInteger num = self.sortAVs.count;
    num++;
    if ([self.cellM desc2].length > 0) {

        [self.upLbl setTitle:[self.cellM desc2] forState:UIControlStateNormal];
        //        self.upLbl.text = [self.cellM desc2];
    }
    self.danmuLbl.text = [NSString stringWithFormat:@"播放:%@  弹幕:%@", [NSString exchangeStr:[self.cellM play]], [NSString exchangeStr:[self.cellM danmaku]]];

    self.btnBar.titleArr = self.arrDict;

    self.cellScroll.delegate = self;

    //    self.cellScroll.cellM = self.cellM;

    //    NSLog(@"%@", self.cellM);

    __weak typeof(self) weakSelf = self;
    self.btnBar.clickBtn = ^(NSInteger tag) {

        weakSelf.cellScroll.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * (tag - 1), 0);

    };

    [self.view bringSubviewToFront:self.topView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveNextTopBarDid:) name:@"moveNextTopBar" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNewController:) name:[NSString stringWithFormat:@"%zd%@", [self.cellM rand], [self.cellM title]] object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerAVSort:) name:[NSString stringWithFormat:@"playerSortAV%@%zd",[self.cellM param],[self.cellM rand]] object:nil];

    if ([NSKeyedUnarchiver unarchiveObjectWithFile:PATH_CELL]) {
        self.dictM = [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_CELL];
        if ([self.dictM valueForKey:[self.cellM param]]) {

            self.collectionBtn.selected = YES;
        }
        else {
            self.collectionBtn.selected = NO;
        }
    }

    if (![NSKeyedUnarchiver unarchiveObjectWithFile:PATH_HIS]) {

        [NSKeyedArchiver archiveRootObject:self.dictMHis toFile:PATH_HIS];
    }
}

- (void)playerAVSort:(NSNotification*)note
{

    self.view.userInteractionEnabled = NO;
    LHSortAV* sort = note.object;

    if ([NSKeyedUnarchiver unarchiveObjectWithFile:PATH_HIS]) {
        self.dictMHis = [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_HIS];
        if ([self.dictMHis valueForKey:[self.cellM param]]) {

            NSDate* date = [NSDate date];

            NSDateFormatter* df = [[NSDateFormatter alloc] init];

            df.dateFormat = @"yyyy-MM-dd HH:mm:ss";

            NSString* dtaeStr = [df stringFromDate:date];

            [self.cellM setHisTime:dtaeStr];

            [self.dictMHis removeObjectForKey:[self.cellM param]];

            [self.dictMHis setValue:self.cellM forKey:[self.cellM param]];

            [NSKeyedArchiver archiveRootObject:self.dictMHis toFile:PATH_HIS];
        }
        else {

            NSDate* date = [NSDate date];

            NSDateFormatter* df = [[NSDateFormatter alloc] init];

            df.dateFormat = @"yyyy-MM-dd HH:mm:ss";

            NSString* dtaeStr = [df stringFromDate:date];

            [self.cellM setHisTime:dtaeStr];

            [self.dictMHis setValue:self.cellM forKey:[self.cellM param]];

            [NSKeyedArchiver archiveRootObject:self.dictMHis toFile:PATH_HIS];
        }
    }

    MoviePlayerViewController* movie = [[MoviePlayerViewController alloc] init];

    __weak typeof(movie) weakMovie = movie;
    __weak typeof(self) weakSelf = self;

    [LHWebAVPlayer getPlayerURL:sort backBlock:^(NSArray* arr) {

        //            NSURL* URL = [NSURL URLWithString:urlString];

        weakMovie.url = [arr firstObject];

        weakMovie.danmaku = [NSString stringWithFormat:@"%@",[arr lastObject]];

        if ([[arr firstObject] length] > 0) {

            if (weakSelf.presentedViewController == nil) {

                [weakSelf presentViewController:movie animated:NO completion:nil];
            }
        }
        else {

            self.view.userInteractionEnabled = YES;
        }

    }];
}

- (void)pushNewController:(NSNotification*)note
{

    LHTaCellM* cellM = note.object;

    LHCellController* cellController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"nextView"];

    cellController.cellM = cellM;

    [self.navigationController pushViewController:cellController animated:YES];

    //    NSLog(@"%@",cellM);
}

- (void)dealloc
{

    [self.downView removeFromSuperview];

    self.downView = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)moveNextTopBarDid:(NSNotification*)note
{
    CGFloat moveY = [note.object floatValue];

    CGFloat moveRY = moveY - self.lastY;

    if (self.btnBar.transform.ty - moveRY >= -160 && self.btnBar.transform.ty - moveRY <= 0) {

        self.btnBar.transform = CGAffineTransformTranslate(self.btnBar.transform, 0, -moveRY);
        self.moveView.transform = CGAffineTransformTranslate(self.btnBar.transform, 0, -moveRY);

        self.cellScroll.transform = CGAffineTransformTranslate(self.cellScroll.transform, 0, -moveRY);
    }
    else if (self.btnBar.transform.ty - moveRY < -160) {

        self.btnBar.transform = CGAffineTransformMakeTranslation(0, -160);

        self.moveView.transform = CGAffineTransformMakeTranslation(0, -160);

        self.cellScroll.transform = CGAffineTransformMakeTranslation(0, -160);
    }
    else if (self.btnBar.transform.ty - moveRY > 0) {

        self.btnBar.transform = CGAffineTransformMakeTranslation(0, 0);

        self.moveView.transform = CGAffineTransformMakeTranslation(0, 0);

        self.cellScroll.transform = CGAffineTransformMakeTranslation(0, 0);
    }

    self.lastY = moveY;
}

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

@end
