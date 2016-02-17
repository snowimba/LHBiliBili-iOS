//
//  LHAtHeaderView.m
//  biUp
//
//  Created by snowimba on 15/12/7.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHAtHeaderView.h"
#import "LHAtScrollView.h"
@interface LHAtHeaderView ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewAt;

@end
@implementation LHAtHeaderView

- (void)awakeFromNib {
    // Initialization code
    
    self.scrollViewAt.backgroundColor = [UIColor clearColor];
    
    CGFloat margin = 20;
    
    CGFloat viewW = ([UIScreen mainScreen].bounds.size.width - 4*margin)/3;
    
    CGFloat viewH = self.scrollViewAt.frame.size.height;
    
    for (NSInteger i = 0; i < 10 ; i++) {
        LHAtScrollView *view = [[LHAtScrollView alloc] initWithFrame:CGRectMake((viewW+margin)*i+margin, 0, viewW, viewH)];
        
        view.backgroundColor = [UIColor colorWithRed:(float)arc4random_uniform(256)/255.0 green:(float)arc4random_uniform(256)/255.0 blue:(float)arc4random_uniform(256)/255.0 alpha:1];;
        [self.scrollViewAt addSubview:view];

    }
    self.scrollViewAt.contentSize = CGSizeMake((viewW+margin)*10+margin, 0);
    
    
    self.scrollViewAt.showsVerticalScrollIndicator = NO;
    
    self.scrollViewAt.showsHorizontalScrollIndicator = NO;
    
    self.scrollViewAt.bounces = NO;
}

@end
