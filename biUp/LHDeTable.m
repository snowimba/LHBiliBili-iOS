
//
//  LHDeTable.m
//  biUp
//
//  Created by snowimba on 15/12/13.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHDeTable.h"
#import "LHDescModel.h"
#import "LHSortAV.h"
#import "LHTaCellM.h"
#import "LHWebAVPlayer.h"
#import "LHSortCell.h"
@interface LHDeTable () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView* tableViewFa;

@end
@implementation LHDeTable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (NSArray*)sortAVs
//{
//
//    if (!_sortAVs) {
//
//        [LHWebAVPlayer getDownLoadURLToSortAV:[self.cellM param] backBlock:^(NSArray* arr, NSString* desc) {
//            _desc = desc;
//            _sortAVs = arr;
////            [NSIndexPath indexPathForRow:0 inSection:0];
//            [self.tableViewFa reloadData];
////            [self.tableViewFa reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//        }];
//    }
//
//    return _sortAVs;
//}

- (void)setCellM:(id)cellM
{

    _cellM = cellM;

    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    self.tableViewFa = tableView;

    [self addSubview:tableView];

    self.tableViewFa.delegate = self;

    self.tableViewFa.dataSource = self;

//                self.tableViewFa.estimatedRowHeight = 44;

//                self.tableViewFa.rowHeight = 80;

    self.tableViewFa.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableViewFa.backgroundColor = [UIColor clearColor];
    
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    NSInteger num = self.sortAVs.count;
    num++;
    return 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (indexPath.row==0) {
        
        LHSortCell *cell = [LHSortCell cellWithTableV:tableView];
        cell.cellM = self.cellM;
        cell.arrDict = self.sortAVs;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    static NSString* ID = @"facell";

    UITableViewCell* cell = [self.tableViewFa dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    if (indexPath.row == 1) {

        cell.textLabel.text = _desc;

        cell.selectionStyle = 0;
    }

    cell.textLabel.font = [UIFont systemFontOfSize:12.0];

    cell.textLabel.numberOfLines = 0;

    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    CGFloat cellH = 44;
    
    if (indexPath.row==0) {
        
//        cellH = (self.sortAVs.count/2+1)*40+20+8*(self.sortAVs.count/2);
        cellH = 77;
    }
    
    if (indexPath.row == 1) {
        cellH = [_desc boundingRectWithSize:CGSizeMake(self.bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0] } context:nil].size.height +16;
    }
    

    return cellH;
}

//- (void)scrollViewDidScroll:(UIScrollView*)scrollView
//{
//
//    if (scrollView.contentOffset.y>=0) {
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveTopBar" object:@(scrollView.contentOffset.y)];
//    }
//
//}

@end
