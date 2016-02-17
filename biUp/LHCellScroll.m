//
//  LHCellScroll.m
//  biUp
//
//  Created by snowimba on 15/12/13.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHCellScroll.h"
#import "LHDeTable.h"
#import "LHDescModel.h"
#import "LHReTableView.h"
#import "LHComTable.h"
#import "LHTaCellM.h"

@interface LHCellScroll ()



@end
@implementation LHCellScroll

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setCellM:(id)cellM{

    _cellM = cellM;
//    NSLog(@"%@",cellM);
    
    self.showsHorizontalScrollIndicator = NO;
    
    self.showsVerticalScrollIndicator = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.bounces = NO;
    
    
    CGFloat vW = [UIScreen mainScreen].bounds.size.width;
    
    for (NSInteger i = 0; i < 3; i++) {
        //            UIView *view = [[UIView alloc] init];
        
        if (i==0) {
            LHDeTable* view = [[LHDeTable alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
            view.sortAVs = [self.sortAVs firstObject];
            view.desc =[self.sortAVs lastObject];
            view.cellM = cellM;
//            NSLog(@"%@",self.cellM);
            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
            
        }else if(i==1){
            LHReTableView* view = [[LHReTableView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
            
            view.cellM = cellM;
            //            NSLog(@"%@",self.cellM);
            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
            self.tableRe = view;
            
        }else{
        
            
            LHComTable* view = [[LHComTable alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
//            view.separatorStyle = 0;
            //            view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
            view.cellM = cellM;
            
            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
        
        }
    }
    
    self.contentSize = CGSizeMake(3 * vW, 0);
    
    self.pagingEnabled = YES;

}

- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {

       
    }
    return self;
}

- (void)awakeFromNib{

    

}

@end
