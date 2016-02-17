//
//  LHCmView.m
//  biUp
//
//  Created by snowimba on 15/12/7.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "AFNetworking.h"
#import "LHCmHeaderView.h"
#import "LHCmTwoView.h"
#import "LHCmView.h"
#import "LHDescModel.h"
#import "LHDescView.h"
#import "LHScrollViewM.h"
#import "LHbottomView.h"
#import "UIImageView+WebCache.h"
#import "YiRefreshHeader.h"
@interface LHCmView () <UIScrollViewDelegate> {
    YiRefreshHeader* refreshHeader;
}
@property (nonatomic, weak) UIScrollView* scrollView;

@property (nonatomic, weak) LHScrollViewM* scrollM;
@property (nonatomic, strong) NSMutableDictionary* dict;
@end
@implementation LHCmView

- (void)getWebData
{

    [self.dict removeAllObjects];

//    NSURL* URL = [NSURL URLWithString:@"http://app.bilibili.com/bangumi/operation_module?_device=android&_hwid=130a7709aeac1793&_ulv=10000&access_key=b938b895c8a7a0af574a6ae76f5631c8&appkey=c1b107428d337928&build=402003&module=index&platform=android&screen=xxhdpi&test=0&ts=1450884356000"];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];

    
    [manager GET:@"http://app.bilibili.com/bangumi/operation_module?_device=android&_hwid=130a7709aeac1793&_ulv=10000&access_key=b938b895c8a7a0af574a6ae76f5631c8&appkey=c1b107428d337928&build=402003&module=index&platform=android&screen=xxhdpi&test=0&ts=1450884356000" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSArray* arr = [responseObject valueForKeyPath:@"result"];
        
        for (NSInteger i = 4; i < arr.count; i++) {
            
            NSDictionary* dictM = arr[i];
            
            [self getDataWith:dictM];
        }
        
        [self setBottomViewData];
        
        [refreshHeader endRefreshing];
        [self.dict removeAllObjects];
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
//    [manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask* task, id responseObject) {
//
//        //            NSLog(@"%@",responseObject);
//
//        NSArray* arr = [responseObject valueForKeyPath:@"result"];
//
//        for (NSInteger i = 4; i < arr.count; i++) {
//
//            NSDictionary* dictM = arr[i];
//
//            [self getDataWith:dictM];
//        }
//
//        [self setBottomViewData];
//
//        [refreshHeader endRefreshing];
//        [self.dict removeAllObjects];
//
//    }
//        failure:^(NSURLSessionTask* operation, NSError* error){
//
//        }];
}

- (void)setBottomViewData
{
    __block NSInteger num = 0;

    [self.dict enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL* _Nonnull stop) {
        NSArray* arr = obj;
        if (arr.count == 4) {
            if (num == 8) {
                return;
            }
            LHbottomView* bottom = (LHbottomView*)[self viewWithTag:num + 300];
            bottom.arrDict = arr;
            bottom.titleLbl.text = [key length] ? key : @"动画";
            num++;
        }
        if (arr.count == 6) {
            self.scrollM.arrDict = arr;
            self.scrollM.titleLbl.text = [key length] ? key : @"推荐剧番";
        }

    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIScrollView* scrollView = [[UIScrollView alloc] init];

        scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

        self.scrollView = scrollView;

        self.scrollView.delegate = self;

        self.scrollView.backgroundColor = [UIColor clearColor];

        [self addSubview:scrollView];

        LHCmHeaderView* headView = [LHCmHeaderView collectionHeadWith];

        headView.backgroundColor = [UIColor clearColor];

        headView.frame = CGRectMake(0, 0, scrollView.frame.size.width, 870);

        [self.scrollView addSubview:headView];

        LHCmTwoView* twoView = [LHCmTwoView towViewWith];

        twoView.backgroundColor = [UIColor clearColor];

        twoView.frame = CGRectMake(0, 870, scrollView.frame.size.width, 859);

        [self.scrollView addSubview:twoView];

        LHScrollViewM* scroll = [LHScrollViewM scrollViewM];

        scroll.frame = CGRectMake(0, 859 + 870 + 7 * 438, self.scrollView.frame.size.width, 244);

        self.scrollM = scroll;

        //            scroll.arrDict = self.arrDict;

        scroll.backgroundColor = [UIColor clearColor];

        [self.scrollView addSubview:scroll];

        for (NSInteger i = 0; i < 8; i++) {

            LHbottomView* bottomView = [LHbottomView bottomViewWith];

            bottomView.backgroundColor = [UIColor clearColor];

            bottomView.tag = i + 300;
            if (i == 7) {
                bottomView.frame = CGRectMake(0, 859 + 870 + 7 * 438 + 244, self.scrollView.frame.size.width, 438);
            }
            else {

                bottomView.frame = CGRectMake(0, 859 + 870 + i * 438, self.scrollView.frame.size.width, 438);
            }

            //            bottomView.arrDict = self.arrDict;

            [self.scrollView addSubview:bottomView];

            //                    [self makeScrollCell:(i - 5)];
        }

        self.scrollView.contentSize = CGSizeMake(0, 859 + 880 + 244 + 8 * 438 + 120);
        //        [self getWebData];

        __weak typeof(self) weakSelf = self;
        // YiRefreshHeader  头部刷新按钮的使用
        refreshHeader = [[YiRefreshHeader alloc] init];
        refreshHeader.scrollView = self.scrollView;
        [refreshHeader header];
        //        typeof(refreshHeader) __weak weakRefreshHeader = refreshHeader;
        refreshHeader.beginRefreshingBlock = ^() {
            // 后台执行：
            [weakSelf getWebData];

        };

        // 是否在进入该界面的时候就开始进入刷新状态
        [refreshHeader beginRefreshing];
    }
    return self;
}

- (void)getDataWith:(NSDictionary*)dict
{

    NSArray* arr = [dict valueForKey:@"body"];
    NSDictionary* arr1 = [dict valueForKey:@"head"];
    NSMutableArray* mutablePosts = [NSMutableArray arrayWithCapacity:arr.count];
    //            NSLog(@"%@",dictM[@"0"]);
    for (NSInteger i = 0; i < arr.count; i++) {

        LHDescModel* post = [LHDescModel cellMWithDict:arr[i]];
        [mutablePosts addObject:post];
    }

    //    self.arrDict = mutablePosts;

    [self.dict setValue:mutablePosts forKey:[NSString stringWithFormat:@"%@", [arr1 valueForKey:@"title"]]];
}

- (NSMutableDictionary*)dict
{

    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    if (scrollView.contentOffset.y >= 0) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveTopBar" object:@(scrollView.contentOffset.y)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
