//
//  LHTopView.m
//  biUp
//
//  Created by snowimba on 15/12/5.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHTopView.h"
#import "LHSlideView.h"

@interface LHTopView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger numTag;

@end

@implementation LHTopView

- (void)setTitleArr:(NSArray*)titleArr
{

    _titleArr = titleArr;

    UIScreen* scr = [UIScreen mainScreen];

    CGFloat btnW = scr.bounds.size.width / 5;
    CGFloat btnH = 30;
    CGFloat btnY = 80;

    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton* navBtn = [[UIButton alloc] init];
        navBtn.frame = CGRectMake(btnW * i, btnY, btnW, btnH);
        [self addSubview:navBtn];
        [navBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        navBtn.titleLabel.textAlignment = NSTextAlignmentCenter;

        [navBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        navBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        navBtn.tag = i + 1;
        [navBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    [(UIButton*)[self viewWithTag:1] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    self.numTag = 1;

    UIView* bottomBar = [[UIView alloc] initWithFrame:CGRectMake(12, 111, btnW - 24, 3)];

    bottomBar.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:239 / 255.0 alpha:1];

    bottomBar.layer.cornerRadius = 1.5;

    [self addSubview:bottomBar];

    self.bottomView = bottomBar;
}

- (IBAction)slideBtn
{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSlideView" object:self userInfo:nil];
//    if (self.clickSlideBtn) {
//        self.clickSlideBtn();
//    }
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
        [(UIButton*)[self viewWithTag:self.numTag] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    [(UIButton*)[self viewWithTag:tagNum] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    self.numTag = tagNum;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
