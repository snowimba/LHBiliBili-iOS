//
//  LHbottomView.m
//  biUp
//
//  Created by snowimba on 15/12/7.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHbottomView.h"

#import "LHAtScrollView.h"

#import "UIImageView+WebCache.h"

#import "AFNetworking.h"

#import "LHDescModel.h"

#import "LHDescView.h"

#import "LHScrollViewM.h"

//#import "UIView+SDAutoLayout.h"

@interface LHbottomView ()

@end
@implementation LHbottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{

    for (NSInteger i = 0; i < 4; i++) {

        LHDescView* tv = [LHDescView viewWithNib];

        UIView* org = [self viewWithTag:i + 1];

        tv.frame = org.bounds;

        tv.tag = i + 400;
        //        tv.sd_layout.leftSpaceToView(org, 0).rightSpaceToView(org, 0).topSpaceToView(org, 0).bottomSpaceToView(org, 0);

        //        tv.testM = arrDict[i];

        [org addSubview:tv];
    }
}

//- (void)layoutSubviews
//{
//
//    [super layoutSubviews];
//
//
//}

- (void)setArrDict:(NSArray*)arrDict
{

    _arrDict = arrDict;

    [self setCellData];
}

- (void)setCellData
{

    for (NSInteger i = 0; i < 4; i++) {

        //        UIView* org = [self viewWithTag:i + 1];
        LHDescView* tv = (LHDescView*)[self viewWithTag:i + 400];

        tv.testM = self.arrDict[i];
    }
}

+ (instancetype)bottomViewWith
{

    return [[[NSBundle mainBundle] loadNibNamed:@"LHbottomView" owner:nil options:nil] lastObject];
}

@end
