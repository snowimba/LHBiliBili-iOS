//
//  LHReTableView.m
//  biUp
//
//  Created by snowimba on 15/12/14.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHReTableView.h"
#import "LHTaCellM.h"
#import "LHTableCellM.h"
#import "LHDescModel.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
@interface LHReTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *arrDict;
@end
@implementation LHReTableView

- (void)webDataRequest:(NSString *)url{
    
    
    
//    NSURL *URL = [NSURL URLWithString:url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *arr = [NSArray arrayWithArray:responseObject];
        //                        NSLog(@"%@",arr);
        
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:arr.count];
        for (NSDictionary *dict in arr) {
            LHTaCellM *cellM = [LHTaCellM cellWithDict:dict];
            [arrM addObject:cellM];
        }
        self.arrDict = arrM;
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
//    [manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
//        
////                    NSLog(@"%@",responseObject);
//        NSArray *arr = [NSArray arrayWithArray:responseObject];
//        //                        NSLog(@"%@",arr);
//        
//        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:arr.count];
//        for (NSDictionary *dict in arr) {
//            LHTaCellM *cellM = [LHTaCellM cellWithDict:dict];
//            [arrM addObject:cellM];
//        }
//        self.arrDict = arrM;
//        
//        [self.tableView reloadData];
//        
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        
//    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LHTableCellM *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%zd%@",[self.cellM rand],[self.cellM title]]object:cell.cellM];
    
}

- (void)setCellM:(id)cellM{

    _cellM = cellM;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    self.tableView = tableView;
    
    [self addSubview:tableView];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = 78;
    
    self.tableView.bounces = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 130 +21 )];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
//    NSString *bas = @"http://api.bilibili.com/search_recommend?_device=android&_hwid=130a7709aeac1793&appkey=c1b107428d337928&main_ver=v2&platform=android&playtag=";
    
//    http://comment.bilibili.com/recommend,3419692
    
    NSString *ur = @"http://comment.bilibili.com/recommend,";
    
    NSString *fan = [ur stringByAppendingString:[cellM param]];
    
    
// http://api.bilibili.com/search_recommend?_device=android&_hwid=130a7709aeac1793&appkey=c1b107428d337928&main_ver=v2&platform=android&playtag=3419692&recommend_type=related_post&rindex=1
    
    
    [self webDataRequest:fan];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    LHTableCellM *cell = [LHTableCellM cellWithTableV:tableView];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.cellM = self.arrDict[indexPath.row];
    
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    
    if (scrollView.contentOffset.y>=0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveNextTopBar" object:@(scrollView.contentOffset.y)];
    }
    
}
//http://comment.bilibili.com/5474064.xml
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
