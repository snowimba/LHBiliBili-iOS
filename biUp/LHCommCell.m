//
//  LHCommCell.m
//  biUp
//
//  Created by snowimba on 15/12/22.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHCommCell.h"
#import "LHCommM.h"
#import "LHCommMH.h"
#import "LHSmallView.h"
#import "UIImageView+WebCache.h"
@interface LHCommCell ()
@property (weak, nonatomic) IBOutlet UIButton* iconBtn;
@property (weak, nonatomic) IBOutlet UIImageView* icon;

@property (weak, nonatomic) IBOutlet UILabel* name;
@property (weak, nonatomic) IBOutlet UILabel* time;
@property (weak, nonatomic) IBOutlet UILabel* good;
@property (weak, nonatomic) IBOutlet UILabel* row;
@property (weak, nonatomic) IBOutlet UILabel* title;
@property (nonatomic, strong) LHSmallView* smallV;
@end
@implementation LHCommCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setCellM:(LHCommMH*)cellM
{

    _cellM = cellM;

    [self.icon sd_setImageWithURL:[NSURL URLWithString:cellM.cellM.face]];

    self.name.text = cellM.cellM.nick;

    self.time.text = cellM.cellM.create_at;

    self.good.text = [NSString stringWithFormat:@"%zd", cellM.cellM.good];

    self.row.text = [NSString stringWithFormat:@"# %zd", cellM.cellM.lv];

    self.title.text = cellM.cellM.msg;

    if (cellM.cellM.reply.count) {

        for (UIView* viewC in self.contentView.subviews) {
            if ([viewC isKindOfClass:[LHSmallView class]]) {
                [viewC removeFromSuperview];
            }
        }
        self.smallV = nil;

        NSUInteger i = 0;

        for (NSDictionary* dict in cellM.cellM.reply) {
            LHSmallView* smallV = [LHSmallView smallView];
            smallV.dict = dict;

            if (i == 0) {

                NSString* str = [NSString stringWithFormat:@"%@: %@", [dict valueForKey:@"msg"], [dict valueForKey:@"nick"]];

                CGFloat cellHS = MAX(56, [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 16 - 56, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.0] } context:nil].size.height + 20.5 + 8);

                smallV.frame = CGRectMake(16, [cellM.cellM.msg boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.0] } context:nil].size.height + 48 + 8 + 8, [UIScreen mainScreen].bounds.size.width - 16 - 8, cellHS);
                [self.contentView addSubview:smallV];

                self.smallV = smallV;

                i++;
            }
            else {

                NSString* str = [NSString stringWithFormat:@"%@: %@", [dict valueForKey:@"msg"], [dict valueForKey:@"nick"]];

                CGFloat cellHS = MAX(56, [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 16 - 56, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.0] } context:nil].size.height + 20.5 + 8);

                smallV.frame = CGRectMake(16, CGRectGetMaxY(self.smallV.frame), [UIScreen mainScreen].bounds.size.width - 16 - 8, cellHS);
                [self.contentView addSubview:smallV];

                self.smallV = smallV;

                i++;
            }
        }
    }
    else {

        for (UIView* viewC in self.contentView.subviews) {
            if ([viewC isKindOfClass:[LHSmallView class]]) {
                [viewC removeFromSuperview];
            }
        }
    }
}

+ (instancetype)cellWithTableV:(UITableView*)table
{

    static NSString* ID = @"comm_cell";

    LHCommCell* cell = [table dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LHCommCell" owner:nil options:nil] lastObject];
    }

    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
