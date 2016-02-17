//
//  LHMainScroll.m
//  biUp
//
//  Created by snowimba on 15/12/6.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHMainScroll.h"
#import "LHDgView.h"
#import "LHSaControllerView.h"
#import "LHFaControllerView.h"
#import "LHAtView.h"
#import "LHCmView.h"
@interface LHMainScroll ()

@end
@implementation LHMainScroll

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        self.showsHorizontalScrollIndicator = NO;
//        
//        self.showsVerticalScrollIndicator = NO;
//        
//        self.backgroundColor = [UIColor clearColor];
//        
//        self.bounces = NO;
//        
//        CGFloat vW = frame.size.width;
//        
//        for (NSInteger i = 0; i < 5; i++) {
//            //            UIView *view = [[UIView alloc] init];
//            if (i == 2) {
//                LHSaControllerView* view = [[LHSaControllerView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, frame.size.height)];
//                view.backgroundColor = [UIColor clearColor];
//                [self addSubview:view];
//            }
//            else if (i == 4) {
//                
//                LHFaControllerView* view = [[LHFaControllerView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, frame.size.height)];
//                
//                view.backgroundColor = [UIColor clearColor];
//                [self addSubview:view];
//            }
//            else if (i == 3) {
//                
//                LHAtView* view = [[LHAtView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, frame.size.height)];
//                
//                view.backgroundColor = [UIColor clearColor];
//                [self addSubview:view];
//            }
//            else if (i == 1) {
//                
//                LHCmView* view = [[LHCmView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, frame.size.height)];
//                
//                view.backgroundColor = [UIColor clearColor];
//                [self addSubview:view];
//            }
//            else {
//                
//                LHDgView* view = [[LHDgView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, frame.size.height)];
//                
//                view.backgroundColor = [UIColor clearColor];
//                [self addSubview:view];
//            }
//        }
//        self.contentSize = CGSizeMake(5 * vW, 0);
//        self.pagingEnabled = YES;
//    }
//    return self;
//
//}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        

    }
    return self;
}


- (void)awakeFromNib{

    
    self.showsHorizontalScrollIndicator = NO;
    
    self.showsVerticalScrollIndicator = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.bounces = NO;
    
    CGFloat vW = [UIScreen mainScreen].bounds.size.width;
    
    for (NSInteger i = 0; i < 5; i++) {
        //            UIView *view = [[UIView alloc] init];
        if (i == 2) {
            LHSaControllerView* view = [[LHSaControllerView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
        }
        else if (i == 4) {
            
            LHFaControllerView* view = [[LHFaControllerView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
            
            view.backgroundColor = [UIColor clearColor];
            
            //                view.tableViewFa.separatorStyle = 0;
            
            [self addSubview:view];
        }
        else if (i == 3) {
            
            LHAtView* view = [[LHAtView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
            
            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
        }
        else if (i == 1) {
            
            LHCmView* view = [[LHCmView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
            
            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
        }
        else {
            
            LHDgView* view = [[LHDgView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
            
            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
        }
    }
    self.contentSize = CGSizeMake(5 * vW, 0);
    self.pagingEnabled = YES;

    


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
