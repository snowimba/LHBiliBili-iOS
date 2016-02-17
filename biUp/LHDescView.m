//
//  LHView.m
//  testWeb
//
//  Created by snowimba on 15/12/10.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHDescModel.h"
#import "LHDescView.h"
#import "UIImageView+WebCache.h"
//#import "AFNetworking.h"
//#import "UIKit+AFNetworking.h"
#import "NSString+Tools.h"

@interface LHDescView ()
@property (weak, nonatomic) IBOutlet UIImageView* iconView;
@property (weak, nonatomic) IBOutlet UILabel* titelView;
@property (weak, nonatomic) IBOutlet UILabel* numLbl;
@property (weak, nonatomic) IBOutlet UILabel* talkLbl;
@property (weak, nonatomic) IBOutlet UIButton* btnV;

@end
@implementation LHDescView

- (void)setTestM:(LHDescModel*)testM
{

    _testM = testM;

    self.titelView.text = testM.title;

    self.numLbl.text = [NSString exchangeStr:testM.play];

    self.talkLbl.text = [NSString exchangeStr:testM.danmaku];

    //    [self.iconView setImageWithURL:[NSURL URLWithString:testM.cover]];

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:testM.cover]];
    
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:testM.cover] placeholderImage:nil options:SDWebImageRetryFailed];
    
    
    [self.btnV addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick
{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushController" object:self.testM];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)viewWithNib
{

    return [[[NSBundle mainBundle] loadNibNamed:@"LHDescView" owner:nil options:nil] lastObject];
}

@end
