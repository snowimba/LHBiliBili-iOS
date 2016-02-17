//
//  LHBtnBar.m
//  biUp
//
//  Created by snowimba on 15/12/13.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHBtnBar.h"


@interface LHBtnBar ()<UIScrollViewDelegate>
@property (nonatomic, assign) NSInteger numTag;
@end
@implementation LHBtnBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setTitleArr:(NSArray*)titleArr
{
    
    _titleArr = titleArr;
    
    UIScreen* scr = [UIScreen mainScreen];
    
    CGFloat btnW = scr.bounds.size.width / 5;
    CGFloat btnH = 40;
    CGFloat btnY = 0;
    
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton* navBtn = [[UIButton alloc] init];
        navBtn.frame = CGRectMake(btnW * i, btnY, btnW, btnH);
        [self addSubview:navBtn];
        [navBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        navBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [navBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        navBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        navBtn.tag = i + 1;
        [navBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [(UIButton*)[self viewWithTag:1] setTitleColor:[UIColor colorWithRed:240 / 255.0 green:120 / 255.0 blue:144 / 255.0 alpha:1] forState:UIControlStateNormal];
    
    self.numTag = 1;
    
    UIView* bottomBar = [[UIView alloc] initWithFrame:CGRectMake(12, 37, btnW - 24, 3)];
    
    bottomBar.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:120 / 255.0 blue:144 / 255.0 alpha:1];
    
    bottomBar.layer.cornerRadius = 1.5;
    
    [self addSubview:bottomBar];
    
    self.bottomView = bottomBar;
}


- (void)navBtnClick:(UIButton*)btn
{
    
    [self changeBtnColor:btn.tag];
    
    if (self.clickBtn) {
        self.clickBtn(btn.tag);
    }
}

- (void)changeBtnColor:(NSInteger)tagNum
{
    
    if (self.numTag != 0) {
        [(UIButton*)[self viewWithTag:self.numTag] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [(UIButton*)[self viewWithTag:tagNum] setTitleColor:[UIColor colorWithRed:240 / 255.0 green:120 / 255.0 blue:144 / 255.0 alpha:1] forState:UIControlStateNormal];
    
    self.numTag = tagNum;
}

@end
