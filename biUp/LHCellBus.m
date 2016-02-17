//
//  LHCellBus.m
//  biUp
//
//  Created by snowimba on 15/12/24.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHCellBus.h"
#import "LHParam.h"
#import "UIImageView+WebCache.h"
@interface LHCellBus ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *desc;

@end
@implementation LHCellBus

- (void)setDict:(NSDictionary *)dict{

    _dict = dict;
    
    [self.icon sd_setImageWithURL:[dict valueForKey:@"face"]];
    
    self.icon.layer.cornerRadius = 20;
    
    self.icon.clipsToBounds = YES;
    
    self.num.text = [dict valueForKey:@"rank"];
    
    self.name.text = [dict valueForKey:@"uname"];
    
    if ([dict valueForKey:@"message"]) {
        self.desc.text = [dict valueForKey:@"message"];
    }
    
    if ([[dict valueForKey:@"rank"] integerValue]<=3) {
        
        self.num.textColor = [UIColor colorWithRed:240/255.0 green:102/255.0 blue:144/255.0 alpha:1];
        
    }else{
    
        self.num.textColor = [UIColor blackColor];
    
    }

}



+ (instancetype)cellWithTableV:(UITableView *)table{
    
    static NSString *ID = @"busCell";
    
    LHCellBus *cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LHCellBus" owner:nil options:nil] lastObject];
    }
    
    return cell;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
