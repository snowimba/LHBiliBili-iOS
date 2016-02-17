//
//  LHCmHeaderView.m
//  biUp
//
//  Created by snowimba on 15/12/7.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHCmHeaderView.h"
//#import "UIView+SDAutoLayout.h"
#import "LHAtScrollView.h"

#import "UIImageView+WebCache.h"

#import "AFNetworking.h"

#import "LHDescModel.h"

#import "LHDescView.h"

#import "LHScrollViewM.h"
//#import "Masonry.h"

#define COUNT 6

@interface LHCmHeaderView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView* headScrollV;
@property (weak, nonatomic) IBOutlet UIPageControl* pageView;

@property (nonatomic, strong) NSTimer* time;

@property (nonatomic, strong) NSArray* arrDict;

@property (nonatomic, strong) NSArray* imageArr;


@end
@implementation LHCmHeaderView


- (void)showSubView
{

    for (NSInteger i = 0; i < 4; i++) {
        LHDescView* tv = [LHDescView viewWithNib];

        UIView* org = [self viewWithTag:i + 1];

        
//        tv.sd_layout.leftSpaceToView(org, 0).rightSpaceToView(org, 0).topSpaceToView(org, 0).bottomSpaceToView(org, 0);

        tv.testM = self.arrDict[i];

        [org addSubview:tv];
    }
}

- (void)setScrollCell
{

    LHScrollViewM* scroll = [LHScrollViewM scrollViewM];

    scroll.arrDict = self.arrDict;

    [[self viewWithTag:110] addSubview:scroll];
    
    scroll.backgroundColor = [UIColor clearColor];

}


- (void)makeADScroll
{

    UIScreen* SCRC = [UIScreen mainScreen];

    CGFloat imageW = SCRC.bounds.size.width;
    CGFloat imageH = self.headScrollV.bounds.size.height;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    for (NSInteger i = 0; i < self.imageArr.count; i++) {

        UIImageView* image = [[UIImageView alloc] init];

        [image sd_setImageWithURL:[NSURL URLWithString:self.imageArr[i]]];
        
//        [image sd_setImageWithURL:[NSURL URLWithString:self.imageArr[i]] placeholderImage:nil options:SDWebImageRetryFailed];

        imageX = imageW * (i + 1);
        image.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [self.headScrollV addSubview:image];
    }
    UIImageView* imageF = [[UIImageView alloc] init];

    [imageF sd_setImageWithURL:[NSURL URLWithString:[self.imageArr lastObject]]];
//     [imageF sd_setImageWithURL:[NSURL URLWithString:[self.imageArr lastObject]] placeholderImage:nil options:SDWebImageRetryFailed];

    imageF.frame = CGRectMake(0, imageY, imageW, imageH);

    [self.headScrollV addSubview:imageF];

    UIImageView* imageL = [[UIImageView alloc] init];

    [imageL sd_setImageWithURL:[NSURL URLWithString:[self.imageArr firstObject]]];
//     [imageL sd_setImageWithURL:[NSURL URLWithString:[self.imageArr firstObject]] placeholderImage:nil options:SDWebImageRetryFailed];

    imageL.frame = CGRectMake(imageW * (self.imageArr.count + 1), imageY, imageW, imageH);

    [self.headScrollV addSubview:imageL];

    self.headScrollV.contentSize = CGSizeMake((self.imageArr.count + 2) * imageW, 0);
    self.headScrollV.contentOffset = CGPointMake(imageW, 0);

    self.headScrollV.pagingEnabled = YES;

    self.headScrollV.showsVerticalScrollIndicator = NO;

    self.headScrollV.showsHorizontalScrollIndicator = NO;

    self.headScrollV.delegate = self;
    self.pageView.currentPage = 0;
    self.pageView.numberOfPages = self.imageArr.count;
    [self time];
}

- (void)awakeFromNib
{
    // Initialization code

//    NSURL* URLAD = [NSURL URLWithString:@"http://app.bilibili.com/bangumi/operation_module?_device=android&_hwid=130a7709aeac1793&_ulv=10000&access_key=b938b895c8a7a0af574a6ae76f5631c8&appkey=c1b107428d337928&build=402003&module=banner&platform=android&screen=xxhdpi&test=0&ts=1450886166000&sign=cc078495cc06a087f954e29724bf7958"];
    AFHTTPSessionManager* managerAD = [AFHTTPSessionManager manager];

    [managerAD GET:@"http://app.bilibili.com/bangumi/operation_module?_device=android&_hwid=130a7709aeac1793&_ulv=10000&access_key=b938b895c8a7a0af574a6ae76f5631c8&appkey=c1b107428d337928&build=402003&module=banner&platform=android&screen=xxhdpi&test=0&ts=1450886166000&sign=cc078495cc06a087f954e29724bf7958" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        
        NSArray* dictM = [responseObject valueForKey:@"list"];
        //        NSLog(@"%@",dictM);
        NSMutableArray* mutablePosts = [NSMutableArray arrayWithCapacity:COUNT];
        //                    NSLog(@"%@",[responseObject valueForKeyPath:@"result"]);
        for (NSDictionary* dic in dictM) {
            
            NSString* icon = [dic valueForKey:@"imageurl"];
            
            [mutablePosts addObject:icon];
        }
        
        self.imageArr = mutablePosts;
        //        NSLog(@"%@",self.imageArr);
        
        //        [self showSubView];
        [self makeADScroll];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
//    [managerAD GET:URLAD.absoluteString parameters:nil success:^(NSURLSessionTask* task, id responseObject) {
//
//        //                            NSLog(@"%@",responseObject);
//
//        //        NSDictionary *dict = [responseObject valueForKeyPath:@"list"];
//
//        NSArray* dictM = [responseObject valueForKey:@"list"];
//        //        NSLog(@"%@",dictM);
//        NSMutableArray* mutablePosts = [NSMutableArray arrayWithCapacity:COUNT];
//        //                    NSLog(@"%@",[responseObject valueForKeyPath:@"result"]);
//        for (NSDictionary* dic in dictM) {
//
//            NSString* icon = [dic valueForKey:@"imageurl"];
//
//            [mutablePosts addObject:icon];
//        }
//
//        self.imageArr = mutablePosts;
//        //        NSLog(@"%@",self.imageArr);
//
//        //        [self showSubView];
//        [self makeADScroll];
//
//    }
//        failure:^(NSURLSessionTask* operation, NSError* error){
//
//        }];

    //    ---------------------------
//    NSURL* URL = [NSURL URLWithString:@"http://app.bilibili.com/bangumi/operation_module?_device=android&_hwid=130a7709aeac1793&_ulv=10000&access_key=b938b895c8a7a0af574a6ae76f5631c8&appkey=c1b107428d337928&build=402003&module=index&platform=android&screen=xxhdpi&test=0&ts=1450884356000"];
    
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];

    [manager GET:@"http://app.bilibili.com/bangumi/operation_module?_device=android&_hwid=130a7709aeac1793&_ulv=10000&access_key=b938b895c8a7a0af574a6ae76f5631c8&appkey=c1b107428d337928&build=402003&module=index&platform=android&screen=xxhdpi&test=0&ts=1450884356000" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* arrD = [responseObject valueForKeyPath:@"result"];
        NSDictionary* dictM = arrD[0];
        
        [self getDataWith:dictM];
        
        [self showSubView];
        
        //        ----------------------------
        
        NSDictionary* dictTM = arrD[1];
        
        [self getDataWith:dictTM];
        
        [self setScrollCell];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
//    
//    [manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask* task, id responseObject) {
//
//        //            NSLog(@"%@",responseObject);
//
//        NSArray* arrD = [responseObject valueForKeyPath:@"result"];
//        NSDictionary* dictM = arrD[0];
//
//        [self getDataWith:dictM];
//
//        [self showSubView];
//
//        //        ----------------------------
//
//        NSDictionary* dictTM = arrD[1];
//
//        [self getDataWith:dictTM];
//
//        [self setScrollCell];
//
//    }
//        failure:^(NSURLSessionTask* operation, NSError* error){
//
//        }];

    //    -------------------
}

- (void)getDataWith:(NSDictionary*)dict
{

    NSArray* arr = [dict valueForKey:@"body"];

    NSMutableArray* mutablePosts = [NSMutableArray arrayWithCapacity:arr.count];
    //            NSLog(@"%@",dictM[@"0"]);
    for (NSInteger i = 0; i < arr.count; i++) {

        LHDescModel* post = [LHDescModel cellMWithDict:arr[i]];
        [mutablePosts addObject:post];
    }

    self.arrDict = mutablePosts;
}

//-(void)setImageView{
//
//
//}

- (void)nextPage
{

    NSInteger page = self.pageView.currentPage;
    if (page == self.imageArr.count - 1) {
        page = 0;
    }
    else
        page++;
    [self.headScrollV setContentOffset:CGPointMake(self.headScrollV.bounds.size.width * (page + 1), 0) animated:YES];

    self.pageView.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{

    [_time invalidate];
    _time = nil;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    NSInteger page = (self.headScrollV.bounds.size.width * 0.5 + self.headScrollV.contentOffset.x) / (self.headScrollV.bounds.size.width);
    if (page >= 1 && page <= self.imageArr.count) {
        self.pageView.currentPage = page - 1;
    }
    else if (page == 0) {

        self.pageView.currentPage = self.imageArr.count-1;
    }
    else if (page == self.imageArr.count+1) {

        self.pageView.currentPage = 0;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{

    [self time];
    //    NSLog(@"¥¥¥");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{

    NSInteger page = self.pageView.currentPage;
    if (page == self.imageArr.count-1) {
        self.headScrollV.contentOffset = CGPointMake(self.headScrollV.bounds.size.width * (page + 1), 0);
    }
    else if (page == 0) {

        self.headScrollV.contentOffset = CGPointMake(self.headScrollV.bounds.size.width * (page + 1), 0);
    }

    //    NSLog(@"@@@@");
}

- (NSTimer*)time
{

    if (_time == nil) {
        NSTimer* time = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        _time = time;
    }

    return _time;
}




+ (instancetype)collectionHeadWith
{

    return [[[NSBundle mainBundle] loadNibNamed:@"LHCmHeaderView" owner:nil options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
