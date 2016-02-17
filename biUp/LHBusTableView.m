//
//  LHBusTableView.m
//  biUp
//
//  Created by snowimba on 15/12/24.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "AFNetworking.h"
#import "LHBusTableView.h"
#import "LHCellBus.h"
#import "LHHeaderView.h"
#import "LHParam.h"
#import "UIKit+AFNetworking.h"
@interface LHBusTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray* arrDict;
@property (nonatomic, weak) UITableView* tableView;
@end
@implementation LHBusTableView

- (void)webDataRequest:(NSString*)url
{

    NSURL* URL = [NSURL URLWithString:url];
    NSURLRequest* req = [NSURLRequest requestWithURL:URL];
    UIWebView* web = [[UIWebView alloc] init];
    NSProgress* progress = nil;
    [web loadRequest:req progress:&progress success:^NSString* _Nonnull(NSHTTPURLResponse* _Nonnull response, NSString* _Nonnull HTML) {

        //                                        NSLog(@"%@",response);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

        NSMutableString* str = [NSMutableString stringWithString:HTML];

        NSData* d = [str dataUsingEncoding:NSUTF8StringEncoding];

        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];

        NSDictionary* dict01 = [dict valueForKey:@"list"];

        self.arrDict = [NSArray arrayWithArray:[dict01 valueForKey:@"list"]];
        //                        NSLog(@"%@",arr);

        [self.tableView reloadData];

        return HTML;

    }
        failure:^(NSError* _Nonnull error){
        }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setCellM:(LHParam*)cellM
{

    _cellM = cellM;

    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];

    [self addSubview:tableView];

    tableView.delegate = self;

    tableView.dataSource = self;

    self.tableView = tableView;

    tableView.bounces = NO;

    //            self.tableViewFa.estimatedRowHeight = 44;

    self.tableView.rowHeight = 60;

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    tableView.backgroundColor = [UIColor clearColor];

    //http://www.bilibili.com/widget/ajaxGetBP?aid=3426217

    NSString* url = [NSString stringWithFormat:@"http://www.bilibili.com/widget/ajaxGetBP?aid=%@", self.cellM.param];

    [self webDataRequest:url];

    LHHeaderView* headerView = [LHHeaderView headerView];

    headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);

    //        headerView.numLbl.text = [NSString stringWithFormat:@"%@",self];

    tableView.tableHeaderView = headerView;

    //    tableView.sectionHeaderHeight = 44;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 130 + 25)];

    __weak typeof(self) weakSelf = self;
    headerView.btnClcike = ^() {

        [weakSelf showBG];

    };
}
- (void)showBG
{

    UIView* BG = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];

    BG.backgroundColor = [UIColor blackColor];

    [self.window addSubview:BG];

    BG.alpha = 0.0;

    [UIView animateWithDuration:0.25 animations:^{
        BG.alpha = 0.7;
    }];

    //    UIView *btnBG = [UIView alloc] initWithFrame:CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];

    [BG addSubview:btn];

    btn.center = BG.center;
    [btn addTarget:self action:@selector(changeTabel:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeTabel:(UIButton*)btn
{

    [btn.superview removeFromSuperview];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.arrDict.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    LHCellBus* cell = [LHCellBus cellWithTableV:tableView];

    cell.dict = self.arrDict[indexPath.row];

    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    if (scrollView.contentOffset.y >= 0) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveSpTopBar" object:@(scrollView.contentOffset.y)];
    }
}
@end
