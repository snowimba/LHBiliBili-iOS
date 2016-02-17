//
//  LHSmallView.m
//  biUp
//
//  Created by snowimba on 15/12/22.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHCommM.h"
#import "LHSmallView.h"
#import "UIImageView+WebCache.h"
@interface LHSmallView ()
@property (weak, nonatomic) IBOutlet UIImageView* icon;
@property (weak, nonatomic) IBOutlet UILabel* name;

@end
@implementation LHSmallView

- (void)awakeFromNib
{
}

+ (instancetype)smallView
{

    return [[[NSBundle mainBundle] loadNibNamed:@"LHSmallView" owner:nil options:nil] lastObject];
}

- (void)setDict:(NSDictionary*)dict
{

    _dict = dict;

//    [self.icon sd_setImageWithURL:[dict valueForKey:@"face"]];

    [self.icon sd_setImageWithURL:[dict valueForKey:@"face"] placeholderImage:[UIImage imageNamed:@"bili_default_avatar"]];
    self.name.text = [NSString stringWithFormat:@"%@: %@", [dict valueForKey:@"nick"], [dict valueForKey:@"msg"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
