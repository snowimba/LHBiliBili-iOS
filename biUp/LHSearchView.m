//
//  LHSearchView.m
//  biUp
//
//  Created by snowimba on 15/12/29.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHSearchView.h"

@interface LHSearchView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray* arrDict;
@property (nonatomic, weak) UITableView* tableView;
@end

@implementation LHSearchView

- (NSMutableArray*)arrDict
{

    if (!_arrDict) {

        NSString* path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"search.plist"];

        _arrDict = [NSMutableArray arrayWithContentsOfFile:path];
        if (!_arrDict) {
            _arrDict = [NSMutableArray array];
        }
    }

    return _arrDict;
}

- (IBAction)backBtn:(UIButton*)sender
{
    //    [UIView animateWithDuration:0.25 animations:^{
    //
    //
    //
    //
    //
    //    }];

    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        [self.textFieldV resignFirstResponder];
    }
        completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
}
- (IBAction)searchBtn:(UIButton*)sender
{

    if (self.textFieldV.text.length) {

        NSString* path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"search.plist"];

        [self.arrDict addObject:self.textFieldV.text];

        [self.arrDict writeToFile:path atomically:YES];

        [self removeFromSuperview];

        if (self.searchBlock) {
            self.searchBlock(self.textFieldV.text);
        }
    }
}

- (void)awakeFromNib
{
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 44 + 8, [UIScreen mainScreen].bounds.size.width - 16, self.arrDict.count * 44 + 44) style:UITableViewStylePlain];

    self.tableView = tableView;

    [self.textFieldV becomeFirstResponder];
    if (self.arrDict.count) {

        [self addSubview:tableView];
    }

    self.textFieldV.delegate = self;

    tableView.delegate = self;

    tableView.dataSource = self;

    tableView.bounces = NO;

    tableView.rowHeight = 44;

    tableView.sectionFooterHeight = 44;

    tableView.separatorStyle = 0;

    tableView.backgroundColor = [UIColor clearColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self searchBtn:nil];
    
    return YES;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    self.textFieldV.text = self.arrDict[indexPath.row];
    if (self.textFieldV.text.length) {

        [self removeFromSuperview];

        if (self.searchBlock) {
            self.searchBlock(self.textFieldV.text);
        }
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.arrDict.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    static NSString* ID = @"search";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }

    cell.textLabel.text = self.arrDict[indexPath.row];

    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.backgroundColor = [UIColor whiteColor];

    cell.imageView.image = [UIImage imageNamed:@"ic_search_history1"];

    return cell;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{

    UIButton* clear = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];

    [clear setTitle:@"清除搜索记录" forState:UIControlStateNormal];

    [clear setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    clear.backgroundColor = [UIColor whiteColor];

    clear.titleLabel.textAlignment = NSTextAlignmentCenter;

    clear.titleLabel.font = [UIFont systemFontOfSize:13.0];

    [clear addTarget:self action:@selector(clearClick:) forControlEvents:UIControlEventTouchUpInside];

    return clear;
}

- (void)clearClick:(UIButton*)btn
{

    [self.arrDict removeAllObjects];

    NSString* path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"search.plist"];

    [self.arrDict writeToFile:path atomically:YES];

    [self.tableView reloadData];

    [self.tableView removeFromSuperview];
}

+ (instancetype)searchView
{

    return [[[NSBundle mainBundle] loadNibNamed:@"LHSearchView" owner:nil options:nil] lastObject];
}

@end
