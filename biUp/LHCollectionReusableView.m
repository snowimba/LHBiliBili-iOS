//
//  LHCollectionReusableView.m
//  biUp
//
//  Created by snowimba on 15/12/6.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHCollectionReusableView.h"

#import "LHCellModel.h"

#import "LHCellView.h"

#import "UIImageView+WebCache.h"

#import "AFNetworking.h"

#define IMAGECOUNT 4
#define SCRC [UIScreen mainScreen]
@interface LHCollectionReusableView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl* pageView;
@property (nonatomic, strong) NSTimer* time;
@property (nonatomic, strong) NSMutableArray* arrDict;
@property (nonatomic, strong) NSMutableArray* imageArr;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger cellNum;

@end

@implementation LHCollectionReusableView

//api/region2/13.json?_device=android&_hwid=130a7709aeac1793&appkey=c1b107428d337928&build=402003&platform=android&ts=1449758668000&sign=9f36da5e90b8345e376a71466a078696
- (NSMutableArray*)arrDict
{

    if (!_arrDict) {
        _arrDict = [NSMutableArray array];
    }

    return _arrDict;
}

- (NSMutableArray*)imageArr
{

    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (void)showSubView
{

    if (self.arrDict.count != self.cellNum) {

        for (NSInteger i = 0; i < 4; i++) {
            LHCellView* tv = [LHCellView viewWithNib];

            UIView* org = [self viewWithTag:i + 1];

            //        tv.sd_layout.leftSpaceToView(org,0).rightSpaceToView(org,0).topSpaceToView(org,0).bottomSpaceToView(org,0);

            tv.frame = org.bounds;
            org.backgroundColor = [UIColor clearColor];

            //        tv.backgroundColor = [UIColor clearColor];

//            tv.cellM = self.arrDict[i];

            tv.tag = i+200;
            
            [org addSubview:tv];
            self.cellNum = self.arrDict.count;
        }
    }
    
    [self setCellData];
}

- (void)setCellData{
    
    
    for (NSInteger i = 0; i < 4; i++) {
        
//        UIView* org = [self viewWithTag:i + 1];
        LHCellView* tv = (LHCellView *)[self viewWithTag:i+200];
        
        //        tv.sd_layout.leftSpaceToView(org,0).rightSpaceToView(org,0).topSpaceToView(org,0).bottomSpaceToView(org,0);
        
//        org.backgroundColor = [UIColor clearColor];
        
        //        tv.backgroundColor = [UIColor clearColor];
        
        tv.cellM = self.arrDict[i];
        
//        [org addSubview:tv];
    }

    

}

- (void)makeADScroll
{

    //    NSLog(@"%@",self.imageArr);
    if (self.imageArr.count != self.count) {

        CGFloat imageW = SCRC.bounds.size.width;
        CGFloat imageH = self.scrollView.bounds.size.height;
        CGFloat imageX = 0;
        CGFloat imageY = 0;
        for (UIView *view in self.scrollView.subviews) {
            [view removeFromSuperview];
        }
        for (NSInteger i = 0; i < self.imageArr.count; i++) {

            UIImageView* image = [[UIImageView alloc] init];

            //        [image sd_setImageWithURL:[NSURL URLWithString:self.imageArr[i]]];
            image.tag = i + 100;
            imageX = imageW * (i + 1);
            image.frame = CGRectMake(imageX, imageY, imageW, imageH);
            [self.scrollView addSubview:image];
        }
        UIImageView* imageF = [[UIImageView alloc] init];

        //    [imageF sd_setImageWithURL:[NSURL URLWithString:[self.imageArr lastObject]]];

        imageF.tag = self.imageArr.count + 100;

        imageF.frame = CGRectMake(0, imageY, imageW, imageH);

        [self.scrollView addSubview:imageF];

        UIImageView* imageL = [[UIImageView alloc] init];

        //    [imageL sd_setImageWithURL:[NSURL URLWithString:[self.imageArr firstObject]]];

        imageL.tag = self.imageArr.count + 101;
        imageL.frame = CGRectMake(imageW * (self.imageArr.count + 1), imageY, imageW, imageH);

        [self.scrollView addSubview:imageL];

        self.scrollView.contentSize = CGSizeMake((self.imageArr.count + 2) * imageW, 0);
        self.scrollView.contentOffset = CGPointMake(imageW, 0);

        self.pageView.numberOfPages = self.imageArr.count;
        //    [self reCellData];
        [self time];
        self.count = self.imageArr.count;
    }
    [self reCellData];
}

- (void)getADataWithURL
{

    [self.imageArr removeAllObjects];
//    NSURL* URLAD = [NSURL URLWithString:@"http://app.bilibili.com/api/region2/13.json?_device=android&_hwid=130a7709aeac1793&appkey=c1b107428d337928&build=402003&platform=android&ts=1449758668000&sign=9f36da5e90b8345e376a71466a078696"];
    AFHTTPSessionManager* managerAD = [AFHTTPSessionManager manager];

    [managerAD GET:@"http://app.bilibili.com/api/region2/13.json?_device=android&_hwid=130a7709aeac1793&appkey=c1b107428d337928&build=402003&platform=android&ts=1449758668000&sign=9f36da5e90b8345e376a71466a078696" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* dict = [responseObject valueForKeyPath:@"result"];
        
        NSArray* dictM = [dict valueForKey:@"banners"];
        //        NSLog(@"%@",dictM);
        //        NSMutableArray* mutablePosts = [NSMutableArray arrayWithCapacity:4];
        //                    NSLog(@"%@",[responseObject valueForKeyPath:@"result"]);
        
        NSInteger num =0;
        for (NSDictionary* dic in dictM) {
            
            if (num==4) {
                break;
            }
            NSString* icon = [dic valueForKey:@"img"];
            
            [self.imageArr addObject:icon];
            num++;
        }
        
        //        self.imageArr = mutablePosts;
        
        [self makeADScroll];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
//    [managerAD GET:URLAD.absoluteString parameters:nil success:^(NSURLSessionTask* task, id responseObject) {
//
//        //                    NSLog(@"%@",responseObject);
//
//        NSDictionary* dict = [responseObject valueForKeyPath:@"result"];
//
//        NSArray* dictM = [dict valueForKey:@"banners"];
//        //        NSLog(@"%@",dictM);
//        //        NSMutableArray* mutablePosts = [NSMutableArray arrayWithCapacity:4];
//        //                    NSLog(@"%@",[responseObject valueForKeyPath:@"result"]);
//
//        NSInteger num =0;
//        for (NSDictionary* dic in dictM) {
//
//            if (num==4) {
//                break;
//            }
//            NSString* icon = [dic valueForKey:@"img"];
//
//            [self.imageArr addObject:icon];
//            num++;
//        }
//
//        //        self.imageArr = mutablePosts;
//
//        [self makeADScroll];
//
//    }
//        failure:^(NSURLSessionTask* operation, NSError* error){
//
//        }];
}

- (void)reCellData
{
    for (NSInteger i = 100; i < self.imageArr.count + 102; i++) {

        UIImageView* image = (UIImageView*)[self.scrollView viewWithTag:i];

        if (i == self.imageArr.count + 100) {
            [image sd_setImageWithURL:[NSURL URLWithString:[self.imageArr lastObject]]];
        }
        else if (i == self.imageArr.count + 101) {
            [image sd_setImageWithURL:[NSURL URLWithString:[self.imageArr firstObject]]];
        }
        else {
            [image sd_setImageWithURL:[NSURL URLWithString:self.imageArr[i - 100]]];
        }
    }
}

- (void)getCellDataWithURL
{
 [self.arrDict removeAllObjects];
//    NSURL* URL = [NSURL URLWithString:@"http://api.bilibili.com/online_list?_device=android&_hwid=130a7709aeac1793&appkey=c1b107428d337928&platform=android&typeid=13&sign=cb5cf6d54ed92fc25c4a8b4292a46692"];

    //    http://www.bilibili.com/api_proxy?app=bangumi&indexType=0&action=site_season_index&pagesize=100&page=1&
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];

    [manager GET:@"http://api.bilibili.com/online_list?_device=android&_hwid=130a7709aeac1793&appkey=c1b107428d337928&platform=android&typeid=13&sign=cb5cf6d54ed92fc25c4a8b4292a46692" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* dictM = [responseObject valueForKeyPath:@"list"];
        
        //        NSMutableArray* mutablePosts = [NSMutableArray arrayWithCapacity:4];
        //            NSLog(@"%@",dictM[@"0"]);
        for (NSInteger i = 0; i < 4; i++) {
            
            LHCellModel* post = [LHCellModel cellMWithDict:dictM[[NSString stringWithFormat:@"%zd", i]]];
            [self.arrDict addObject:post];
        }
        
        //        self.arrDict = mutablePosts;
        
        [self showSubView];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
//    [manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask* task, id responseObject) {
//
////        /Users/snowimba/Desktop/MySvn/copy/biUp/biUp/LHCollectionReusableView.m:166:16: 'GET:parameters:success:failure:' is deprecated
//        //            NSLog(@"%@",responseObject);
//
//        NSDictionary* dictM = [responseObject valueForKeyPath:@"list"];
//
////        NSMutableArray* mutablePosts = [NSMutableArray arrayWithCapacity:4];
//        //            NSLog(@"%@",dictM[@"0"]);
//        for (NSInteger i = 0; i < 4; i++) {
//
//            LHCellModel* post = [LHCellModel cellMWithDict:dictM[[NSString stringWithFormat:@"%zd", i]]];
//            [self.arrDict addObject:post];
//        }
//
////        self.arrDict = mutablePosts;
//
//        [self showSubView];
//
//    }
//        failure:^(NSURLSessionTask* operation, NSError* error){
//
//        }];
}

- (void)awakeFromNib
{
    
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.scrollView.delegate = self;
    
    self.pageView.currentPage = 0;
}

- (void)nextPage
{

    NSInteger page = self.pageView.currentPage;
    if (page == self.imageArr.count - 1) {
        page = 0;
    }
    else
        page++;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * (page + 1), 0) animated:YES];

    self.pageView.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{

    [_time invalidate];
    _time = nil;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    NSInteger page = (self.scrollView.bounds.size.width * 0.5 + self.scrollView.contentOffset.x) / (self.scrollView.bounds.size.width);
    if (page >= 1 && page <= self.imageArr.count) {
        self.pageView.currentPage = page - 1;
    }
    else if (page == 0) {

        self.pageView.currentPage = self.imageArr.count - 1;
    }
    else if (page == self.imageArr.count + 1) {

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
    if (page == self.imageArr.count - 1) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width * (page + 1), 0);
    }
    else if (page == 0) {

        self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width * (page + 1), 0);
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

    return [[[NSBundle mainBundle] loadNibNamed:@"LHCollectionReusableView" owner:nil options:nil] lastObject];
}

@end
