
//
//  LHTableCellM.m
//  biUp
//
//  Created by snowimba on 15/12/13.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHTaCellM.h"
#import "LHTableCellM.h"
#import "NSString+Tools.h"
#import "UIImageView+WebCache.h"
@interface LHTableCellM ()

@property (weak, nonatomic) IBOutlet UIImageView* iconImage;
@property (weak, nonatomic) IBOutlet UILabel* titelLbl;
@property (weak, nonatomic) IBOutlet UILabel* upLbl;
@property (weak, nonatomic) IBOutlet UILabel* playLbl;
@property (weak, nonatomic) IBOutlet UIImageView* danma;

@property (weak, nonatomic) IBOutlet UIImageView* playImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end
@implementation LHTableCellM

- (void)awakeFromNib
{

    // Initialization code
}

- (void)setCellM:(LHTaCellM*)cellM
{

    _cellM = cellM;

    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:cellM.small_cover]];
    
//    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:cellM.small_cover] placeholderImage:nil options:SDWebImageRetryFailed];

    self.titelLbl.text = cellM.title;

    if ([[cellM collTime] length] > 0) {
       
        self.timeLbl.text = [NSString stringWithFormat:@"收藏时间: %@", [cellM collTime]];
    }
    
    if ([[cellM hisTime] length] > 0) {
        self.timeLbl.text = [NSString stringWithFormat:@"观看时间: %@", [cellM hisTime]];
    }
    
    self.upLbl.text = [NSString exchangeStr:cellM.play];
    self.playLbl.text = [NSString exchangeStr:cellM.danmaku];

    //    self.upLbl.text = [NSString exchangeStr:cellM.play];
    ////    self.playLbl.text = [[cellM timeText] length]>0?[cellM timeText]:[NSString exchangeStr:cellM.danmaku];
}

+ (instancetype)cellWithTableV:(UITableView*)table
{

    static NSString* ID = @"tacell";

    LHTableCellM* cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LHTableCellM" owner:nil options:nil] lastObject];
    }

    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
