//
//  LHScrollViewM.m
//  biUp
//
//  Created by snowimba on 15/12/12.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHAtScrollView.h"
#import "LHDescModel.h"
#import "LHScrollViewM.h"

@interface LHScrollViewM ()

@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (nonatomic, assign) NSInteger count;
@end
@implementation LHScrollViewM

- (void)setArrDict:(NSArray*)arrDict
{

    _arrDict = arrDict;

    if (self.count != arrDict.count) {

        self.scrollView.backgroundColor = [UIColor clearColor];

        CGFloat margin = 20;
        //
        //    NSLog(@"[UIScreen mainScreen]---%f",[UIScreen mainScreen].bounds.size.width);
        //    NSLog(@"self.bounds----%f",self.bounds.size.width);
        //    NSLog(@"self.scrollView----%f",self.scrollView.bounds.size.width);
        CGFloat viewW = ([UIScreen mainScreen].bounds.size.width - 4 * margin) / 3;

        CGFloat viewH = [UIScreen mainScreen].bounds.size.height;

        for (NSInteger i = 0; i < arrDict.count; i++) {
            LHAtScrollView* view = [LHAtScrollView atScrollViewWith];

            view.frame = CGRectMake((viewW + margin) * i + margin, 0, viewW, viewH);

//            view.cellM = arrDict[i];

            view.tag = i + 202;

            view.backgroundColor = [UIColor whiteColor];

            [self.scrollView addSubview:view];
        }
        self.scrollView.contentSize = CGSizeMake((viewW + margin) * (self.arrDict.count) + margin, 0);

        self.scrollView.showsVerticalScrollIndicator = NO;

        self.scrollView.showsHorizontalScrollIndicator = NO;

        self.scrollView.bounces = NO;
        self.count = arrDict.count;
    }
    [self setCellData];
}

-(void)setCellData{

    for (NSInteger i = 0; i < self.arrDict.count ; i++) {
        
        LHAtScrollView* view = (LHAtScrollView *)[self viewWithTag:i+202];
        
        view.cellM = self.arrDict[i];
        
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)scrollViewM
{

    return [[[NSBundle mainBundle] loadNibNamed:@"LHScrollViewM" owner:nil options:nil] lastObject];
}
@end
