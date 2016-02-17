//
//  LHComTable.m
//  biUp
//
//  Created by snowimba on 15/12/19.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "AFNetworking.h"
#import "LHComTable.h"
#import "LHCommCell.h"
#import "LHCommM.h"
#import "LHCommMH.h"
#import "LHDescModel.h"
#import "LHFooterView.h"
#import "LHParam.h"
#import "LHTaCellM.h"
#import "LHTableCellM.h"
#import "UIKit+AFNetworking.h"
#import "YiRefreshFooter.h"
@interface LHComTable () <UITableViewDelegate, UITableViewDataSource>
{

    YiRefreshFooter *refreshFooter;

}
@property (nonatomic, assign) NSInteger page;

@end
@implementation LHComTable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(NSMutableArray *)arrDict02{

    if (!_arrDict02) {
        _arrDict02 = [NSMutableArray array];
        
    }

    return _arrDict02;
}

- (void)webDataRequest:(NSString*)param
{

    self.page++;
    
    NSString* fan = [NSString stringWithFormat:@"http://api.bilibili.com/feedback?type=jsonp&ver=3&callback=jQuery172019889523880556226_1446769749937&mode=arc&_=1446769758188&page=%zd&aid=%@&pagesize=20&", self.page, param];
    //URL	NSURL *	@"htp://api.bilibili.com/feedback?type=jsonp&ver=3&callback=jQuery172019889523880556226_1446769749937&mode=arc&_=1446769758188&page=1&aid=3028636&pagesize=20&"	0x00007fd61e7aa960
    NSURL* URL = [NSURL URLWithString:fan];

    NSURLRequest* req = [NSURLRequest requestWithURL:URL];

    UIWebView* web = [[UIWebView alloc] init];
//    NSLog(@"%@",fan);
//    [[AFHTTPSessionManager manager] GET:fan parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        NSLog(@"%@",responseObject);
//        self.tableView.sectionFooterHeight = 21;
////        NSMutableString* str = [NSMutableString stringWithString:HTML];
////        
////        [str deleteCharactersInRange:NSMakeRange(0, 43)];
////        
////        [str deleteCharactersInRange:NSMakeRange(str.length - 2, 2)];
////        
////        NSData* d = [str dataUsingEncoding:NSUTF8StringEncoding];
////        
////        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
//        
////        NSArray* arr01 = [NSArray arrayWithArray:[responseObject valueForKey:@"hotList"]];
//        NSDictionary *dict01 = [NSDictionary dictionaryWithDictionary:[responseObject valueForKey:@"hotList"]];
//        
////                    NSLog(@"%@---%zd",dict01,dict01.count);
//        NSMutableArray* arrM = [NSMutableArray arrayWithCapacity:dict01.count];
//        
//        [dict01 enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//           
//            LHCommM* cellM = [LHCommM cellWithDict:obj];
//            LHCommMH* cellH = [[LHCommMH alloc] init];
//            
//            cellH.cellM = cellM;
//            
//            [arrM addObject:cellH];
//            
//        }];
//        
////        for (NSDictionary* dict in dict01) {
////            NSLog(@"%@",dict);
////            LHCommM* cellM = [LHCommM cellWithDict:dict];
////            LHCommMH* cellH = [[LHCommMH alloc] init];
////            
////            cellH.cellM = cellM;
////            
////            [arrM addObject:cellH];
////        }
//        self.arrDict = arrM;
//        //            [self.arrDict addObjectsFromArray:arrM];
//        
////        NSArray* arr02 = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
//         NSDictionary *dict02 = [NSDictionary dictionaryWithDictionary:[responseObject valueForKey:@"list"]];
//        
//        //                NSMutableArray* arrM02 = [NSMutableArray arrayWithCapacity:arr02.count];
//        
//        [dict02 enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//           
//            LHCommM* cellM = [LHCommM cellWithDict:obj];
//            
//            LHCommMH* cellH = [[LHCommMH alloc] init];
//            
//            cellH.cellM = cellM;
//            [self.arrDict02 addObject:cellH];
//            
//        }];
//        
////        for (NSDictionary* dict in dict02) {
//////            NSLog(@"%@",dict);
////            LHCommM* cellM = [LHCommM cellWithDict:dict];
////            
////            LHCommMH* cellH = [[LHCommMH alloc] init];
////            
////            cellH.cellM = cellM;
////            [self.arrDict02 addObject:cellH];
////        }
//        //                [self.arrDict02 addObject:arrM02];
//        
//        //            self.arrDict = arrM;
//        
//        [self.tableView reloadData];
//        [refreshFooter endRefreshing];
//
//        
//        
////        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    NSProgress* progress = nil;

    [web loadRequest:req progress:&progress
        success:^NSString* _Nonnull(NSHTTPURLResponse* _Nonnull response, NSString* _Nonnull HTML) {

            if (HTML != nil) {
                self.tableView.sectionFooterHeight = 21;
                NSMutableString* str = [NSMutableString stringWithString:HTML];

                [str deleteCharactersInRange:NSMakeRange(0, 43)];

                [str deleteCharactersInRange:NSMakeRange(str.length - 2, 2)];

                NSData* d = [str dataUsingEncoding:NSUTF8StringEncoding];

                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];

                NSArray* arr01 = [NSArray arrayWithArray:[dict valueForKey:@"hotList"]];

                //            NSLog(@"%@",dict);

                NSMutableArray* arrM = [NSMutableArray arrayWithCapacity:arr01.count];
                for (NSDictionary* dict in arr01) {
                    LHCommM* cellM = [LHCommM cellWithDict:dict];
                    LHCommMH* cellH = [[LHCommMH alloc] init];

                    cellH.cellM = cellM;

                    [arrM addObject:cellH];
                }
                self.arrDict = arrM;
                //            [self.arrDict addObjectsFromArray:arrM];

                NSArray* arr02 = [NSArray arrayWithArray:[dict valueForKey:@"list"]];

//                NSMutableArray* arrM02 = [NSMutableArray arrayWithCapacity:arr02.count];
                for (NSDictionary* dict in arr02) {
                    LHCommM* cellM = [LHCommM cellWithDict:dict];

                    LHCommMH* cellH = [[LHCommMH alloc] init];

                    cellH.cellM = cellM;
                    [self.arrDict02 addObject:cellH];
                }
//                [self.arrDict02 addObject:arrM02];

                //            self.arrDict = arrM;

                [self.tableView reloadData];
                [refreshFooter endRefreshing];
            }
            return HTML;
        }
        failure:^(NSError* _Nonnull error){
        }];
}
- (void)setCellM:(id)cellM
{

    _cellM = cellM;

    self.page = 0;
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    self.tableView = tableView;

    [self addSubview:tableView];

    self.tableView.delegate = self;

    self.tableView.dataSource = self;

    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.backgroundColor = [UIColor clearColor];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 130)];

    self.tableView.showsVerticalScrollIndicator = NO;

    //    NSString* fan = [NSString stringWithFormat:@"http://api.bilibili.com/feedback?type=jsonp&ver=3&callback=jQuery172019889523880556226_1446769749937&mode=arc&_=1446769758188&page=1&aid=3554632&pagesize=20&", [cellM param]];

//    htp://api.bilibili.com/feedback?type=jsonp&ver=3&callback=jQuery172019889523880556226_1446769749937&mode=arc&_=1446769758188&page=1&aid=3028636&pagesize=20&
//    self.tableView.bounces = NO;
    [self webDataRequest:[cellM param]];
    __weak typeof (self)weakSelf = self;
    refreshFooter=[[YiRefreshFooter alloc] init];
    refreshFooter.scrollView=tableView;
    [refreshFooter footer];
//    typeof(refreshFooter) __weak weakRefreshFooter = refreshFooter;
    refreshFooter.beginRefreshingBlock=^(){
        // 后台执行：
        
       [weakSelf webDataRequest:[cellM param]];
    };

    
    

    //    self.tableView.estimatedRowHeight = 80;

    //    858036363
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {

        return self.arrDict.count;
    }
    else {

        return self.arrDict02.count;
    }

    //    return self.arrDict.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //    NSLog(@"cell");
    LHCommCell* cell = [LHCommCell cellWithTableV:tableView];

    //        cell.cellM =
    if (indexPath.section == 0) {

        cell.cellM = self.arrDict[indexPath.row];
    }
    else {

        cell.cellM = self.arrDict02[indexPath.row];
    }

    return cell;
}
//

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{

    LHFooterView* footView = [LHFooterView footerView];

    footView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 21);

    if (section == 0) {
        return footView;
    }
    else {

        return [[UIView alloc] init];
    }
}

- (void)loadMoreHotList
{

    //    NSLog(@"$$$$");
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (indexPath.section == 0) {
        return [self.arrDict[indexPath.row] cellH];
    }
    else {

        return [self.arrDict02[indexPath.row] cellH];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    if (scrollView.contentOffset.y >= 0) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveNextTopBar" object:@(scrollView.contentOffset.y)];
    }
}

@end
