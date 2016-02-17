//
//  LHOneCell.m
//  biUp
//
//  Created by snowimba on 15/12/25.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHOneCell.h"
#import "LHParam.h"
@implementation LHOneCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setArrDict:(NSArray*)arrDict
{

    _arrDict = arrDict;

    CGFloat marginRL = 20;
    CGFloat margin = 10;
    CGFloat btnW = ([UIScreen mainScreen].bounds.size.width - 3 * margin - 2 * marginRL) / 4;

    for (NSInteger i = 0; i < arrDict.count; i++) {

        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(marginRL + (btnW + margin) * (i % 4), 78 + marginRL + (btnW / 2.5 + margin) * (i / 4), btnW, btnW / 2.5)];

        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:[arrDict[i] index] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 3;
        btn.clipsToBounds = YES;

        btn.titleLabel.font = [UIFont systemFontOfSize:13.0];

        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:btn];

        //        btn.userInteractionEnabled = YES;
        //
        //        btn.enabled = YES;
        btn.tag = i;

        [btn addTarget:self action:@selector(AVPlyer:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)AVPlyer:(UIButton*)btn
{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"playerSpAV" object:self.arrDict[btn.tag]];
}

//68 + 20 + (([UIScreen mainScreen].bounds.size.width - 3 * 10 - 2 * 20) / 8 + 10) * (arrDict.count-1 / 4)+8+([UIScreen mainScreen].bounds.size.width - 3 * 10 - 2 * 20) / 8

+ (instancetype)cellWithTableV
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LHOneCell" owner:nil options:nil] lastObject];
}

@end
