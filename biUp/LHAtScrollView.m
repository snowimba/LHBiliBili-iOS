//
//  LHAtScrollView.m
//  biUp
//
//  Created by snowimba on 15/12/7.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHAtScrollView.h"
#import "LHDescModel.h"
#import "UIImageView+WebCache.h"

@interface LHAtScrollView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titelLbl;

@property (weak, nonatomic) IBOutlet UILabel *numLbl;


@end
@implementation LHAtScrollView

- (void)setCellM:(LHDescModel *)cellM{

    _cellM = cellM;
    self.titelLbl.text = cellM.title;
    
    self.numLbl.text = cellM.desc1;
    
//    self.talkLbl.text = testM.play;
    
    //    [self.iconView setImageWithURL:[NSURL URLWithString:testM.cover]];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:cellM.cover]];
    

}

+ (instancetype)atScrollViewWith{

    
    return [[[NSBundle mainBundle] loadNibNamed:@"LHAtScrollView" owner:nil options:nil] lastObject];

}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
