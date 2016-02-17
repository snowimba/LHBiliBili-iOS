//
//  LHCellView.m
//  biUp
//
//  Created by snowimba on 15/12/10.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHCellView.h"
#import "LHCellModel.h"
#import "UIImageView+WebCache.h"
@interface LHCellView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;


@end
@implementation LHCellView

- (IBAction)pushNextVC:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushController" object:self.cellM];
    
}

- (void)setCellM:(LHCellModel *)cellM{

    _cellM = cellM;
    
    self.titleView.text = cellM.title;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:cellM.small_cover]];
    
//       [self.iconView sd_setImageWithURL:[NSURL URLWithString:cellM.small_cover] placeholderImage:nil options:SDWebImageRetryFailed];

    

}

+ (instancetype)viewWithNib{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"LHCellView" owner:nil options:nil]lastObject];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
