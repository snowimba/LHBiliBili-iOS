//
//  LHComSpTable.m
//  biUp
//
//  Created by snowimba on 15/12/24.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHComSpTable.h"
#import "LHHeaderView.h"
#import "LHShop.h"

@interface LHComSpTable ()
@property (nonatomic, strong) LHHeaderView* head;

@end
@implementation LHComSpTable

- (void)layoutSubviews
{

    [super layoutSubviews];
   
}

- (void)setArrSp:(NSArray *)arrSp{

    _arrSp = arrSp;
    if (!_head) {
        
        LHHeaderView* headerView = [LHHeaderView headerView];
        _head = headerView;
    }
    
    self.head.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    
    //        headerView.numLbl.text = [NSString stringWithFormat:@"%@",self];
    
    self.tableView.tableHeaderView = self.head;
    
    //    self.tableView.sectionHeaderHeight = 44;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 130)];
    __weak typeof(self) weakSelf = self;
    self.head.btnClcike = ^() {
        
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    if (scrollView.contentOffset.y >= 0) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveSpTopBar" object:@(scrollView.contentOffset.y)];
    }
}
@end
