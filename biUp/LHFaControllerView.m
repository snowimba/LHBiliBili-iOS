//
//  LHFaControllerView.m
//  biUp
//
//  Created by snowimba on 15/12/7.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHFaControllerView.h"
#import "LHFaHeader.h"
#import "LHFaheadModel.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
//#import "MJRefresh.h"

//#import "UIRefreshControl+AFNetworking.h"
//#import "UIAlertView+AFNetworking.h"
@interface LHFaControllerView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableViewFa;
@property (nonatomic,strong) NSArray *arrDict;

//@property (nonatomic,strong) MJRefreshFooter *refoot;
@end
@implementation LHFaControllerView


- (void)webDataRequest{

    
//    NSLog(@"$$$");
//        NSURL *URL = [NSURL URLWithString:@"http://app.bilibili.com/api/search_rank.json?_device=android&_hwid=130a7709aeac1793&appkey=c1b107428d337928&build=402003&platform=android&ts=1449759338000&sign=35bb746ed62c2a8fbfc445b09dbe06d7"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"http://app.bilibili.com/api/search_rank.json?_device=android&_hwid=130a7709aeac1793&appkey=c1b107428d337928&build=402003&platform=android&ts=1449759338000&sign=35bb746ed62c2a8fbfc445b09dbe06d7" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *arr = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"list"]];
        //                        NSLog(@"%@",arr);
        
        self.arrDict = arr;
        
        [self.tableViewFa reloadData];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
//        [manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
//    
////            NSLog(@"%@",responseObject);
//            NSArray *arr = [NSArray arrayWithArray:[responseObject valueForKeyPath:@"list"]];
////                        NSLog(@"%@",arr);
//    
//            self.arrDict = arr;
//    
//            [self.tableViewFa reloadData];
//    
//        } failure:^(NSURLSessionTask *operation, NSError *error) {
//    
//        }];
//    
    
//    [self.refoot setRefreshingWithStateOfTask:task];
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableViewFa = tableView;
        
        [self addSubview:tableView];
        
        self.tableViewFa.delegate = self;
        
        self.tableViewFa.dataSource = self;
        
        LHFaHeader *headView = [LHFaHeader faHeadWith];
        
        headView.frame = CGRectMake(0, 0, frame.size.width, 266);
        
        self.tableViewFa.tableHeaderView = headView;
        
//        self.tableViewFa.estimatedRowHeight = 44;
        
        self.tableViewFa.rowHeight = 44;
        
        self.tableViewFa.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableViewFa.backgroundColor = [UIColor clearColor];
        
        self.tableViewFa.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 120)];
        
//        MJRefreshHeader *rehead = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(webDataRequest)];
//        self.tableViewFa.tableHeaderView = rehead;
       
//        
//         MJRefreshAutoFooter *refoot = [ MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(webDataRequest)];
//        
//        refoot.frame = CGRectMake(0, 0, frame.size.width, 120);
//        self.tableViewFa.mj_footer = refoot;
//        
//        self.refoot = refoot;
        
        
        [self webDataRequest];
        
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.arrDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"facell";
    
    UITableViewCell *cell = [self.tableViewFa dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
   
        
        cell.textLabel.text = [NSString stringWithFormat:@"  %zd:  %@",indexPath.item+1,[self.arrDict[indexPath.item] valueForKey:@"keyword"]];
        cell.textLabel.textColor = [UIColor colorWithRed:(float)arc4random_uniform(256)/255.0 green:(float)arc4random_uniform(256)/255.0 blue:(float)arc4random_uniform(256)/255.0 alpha:1];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.backgroundColor = [UIColor clearColor];
    
    return cell;

}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    
    if (scrollView.contentOffset.y>=0) {
        
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
