//
//  LHMainViewController.m
//  biUp
//
//  Created by snowimba on 15/12/5.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHCellController.h"
#import "LHDescModel.h"
#import "LHDescView.h"
#import "LHMainScroll.h"
#import "LHMainViewController.h"
#import "LHSearchController.h"
#import "LHSearchView.h"
#import "LHShop.h"
#import "LHSlideView.h"
#import "LHSpController.h"
#import "LHTopView.h"
#import "LHHistoryController.h"
#import "LHDownLoadController.h"
#import <SDImageCache.h>
#define SCR [UIScreen mainScreen]

@interface LHMainViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView* scrollViewM;
@property (weak, nonatomic) IBOutlet LHTopView* topView;
//@property (nonatomic, weak) LHMainScroll* mScrollView;
@property (nonatomic, strong) NSArray* arrDict;
@property (nonatomic, weak) LHSlideView* slidView;
@property (nonatomic, assign) CGFloat lastY;
@property (nonatomic,strong) SDImageCache *imageCache;

@end

@implementation LHMainViewController

-(SDImageCache *)imageCache{

    if (!_imageCache) {
        _imageCache = [SDImageCache sharedImageCache];
    }

    return _imageCache;
}


- (IBAction)searchBtn:(UIButton*)sender
{
    //    NSLog(@"***");
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
- (IBAction)downLoad:(id)sender {
    
     LHDownLoadController* vcC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DownLoad"];
    
    [self.navigationController pushViewController:vcC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageCache.maxCacheAge = 60*60*24;
    
//    self.imageCache.maxCacheSize = 1024*1024*100;
    
    self.imageCache.shouldDecompressImages = YES;
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.imageCache cleanDisk];
    //

    self.topView.titleArr = self.arrDict;

    self.scrollViewM.delegate = self;

    //    self.mScrollView = mainScrollV;
    LHSlideView* slideV = [LHSlideView slideViewWith];

    slideV.frame = CGRectMake(-SCR.bounds.size.width + 15, 0, SCR.bounds.size.width, SCR.bounds.size.height);

    [self.navigationController.view addSubview:slideV];
    [self.navigationController.view bringSubviewToFront:slideV];

    self.slidView = slideV;

    __weak typeof(self) weakSelf = self;

    self.topView.clickBtn = ^(NSInteger tag) {

        weakSelf.scrollViewM.contentOffset = CGPointMake(SCR.bounds.size.width * (tag - 1), 0);

    };

//    self.topView.clickSlideBtn = ^() {
//
//        [weakSelf slideView];
//
//    };
//
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchBtn:) name:@"UITouchText.search" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideView) name:@"ShowSlideView" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveTopBarDid:) name:@"moveTopBar" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushController:) name:@"pushController" object:nil];

    //    pushSpController

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSpController:) name:@"pushSpController" object:nil];
    
    

    self.slidView.showSlide = ^() {

        [UIView animateWithDuration:0.5
                         animations:^{
                             weakSelf.slidView.transform = CGAffineTransformMakeTranslation(SCR.bounds.size.width - 15, 0);
                             //            }
                             //            completion:^(BOOL finished) {
                             //                [UIView animateWithDuration:0.2
                             //                                 animations:^{
                             weakSelf.slidView.shadeView.alpha = 0.55;

                             //                                 }];
                         }];

    };
    
    self.slidView.pushBlock = ^(UIViewController *vc){
    
        if ([vc isKindOfClass:[LHDownLoadController class]]) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.slidView.alpha = 0;
            });
            
        }
        [weakSelf.navigationController pushViewController:vc animated:NO];
    
    };
}

- (void)pushController:(NSNotification*)note
{

    self.slidView.hidden = YES;
    LHDescModel* cellM = note.object;

    LHCellController* cellController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"nextView"];

    cellController.cellM = cellM;
    [self.navigationController pushViewController:cellController animated:YES];

    //    NSLog(@"%@",cellM);
}

- (void)pushSpController:(NSNotification*)note
{

    self.slidView.hidden = YES;
    LHShop* cellM = note.object;

    LHSpController* cellController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SPView"];

    cellController.cellM = cellM;
    [self.navigationController pushViewController:cellController animated:YES];

    //    NSLog(@"%@",cellM);
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
    self.slidView.hidden = NO;
    self.slidView.alpha = 1;

}

- (void)slideView
{

    [self.view bringSubviewToFront:self.slidView];

    [UIView animateWithDuration:0.5
        animations:^{
            self.slidView.transform = CGAffineTransformMakeTranslation(SCR.bounds.size.width - 15, 0);
            self.slidView.shadeView.alpha = 0.55;
        }
        completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3
                             animations:^{

                             }];
        }];
}

- (void)moveTopBarDid:(NSNotification*)note
{
    CGFloat moveY = [note.object floatValue];

    CGFloat moveRY = moveY - self.lastY;

    if (self.topView.transform.ty - moveRY >= -70 && self.topView.transform.ty - moveRY <= 0) {

        self.topView.transform = CGAffineTransformTranslate(self.topView.transform, 0, -moveRY);

        self.scrollViewM.transform = CGAffineTransformTranslate(self.scrollViewM.transform, 0, -moveRY);
    }
    else if (self.topView.transform.ty - moveRY < -70) {

        self.topView.transform = CGAffineTransformMakeTranslation(0, -70);

        self.scrollViewM.transform = CGAffineTransformMakeTranslation(0, -70);
    }
    else if (self.topView.transform.ty - moveRY > 0) {

        self.topView.transform = CGAffineTransformMakeTranslation(0, 0);

        self.scrollViewM.transform = CGAffineTransformMakeTranslation(0, 0);
    }

    self.lastY = moveY;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    self.topView.bottomView.transform = CGAffineTransformMakeTranslation(scrollView.contentOffset.x / 5, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    NSUInteger tagNum = (scrollView.contentOffset.x + SCR.bounds.size.width * 0.5) / SCR.bounds.size.width + 1;
    [self.topView changeBtnColor:tagNum];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSArray*)arrDict
{

    if (!_arrDict) {
        _arrDict = [NSArray arrayWithObjects:@"番剧", @"推荐", @"分区", @"关注", @"发现", nil];
    }

    return _arrDict;
}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.imageCache clearMemory];
    
}

@end
