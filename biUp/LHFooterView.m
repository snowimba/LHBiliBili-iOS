//
//  LHFooterView.m
//  biUp
//
//  Created by snowimba on 15/12/24.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHFooterView.h"

@implementation LHFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)footerView{


    return [[[NSBundle mainBundle] loadNibNamed:@"LHFooterView" owner:nil options:nil] lastObject];
}
@end
