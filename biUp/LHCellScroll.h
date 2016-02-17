//
//  LHCellScroll.h
//  biUp
//
//  Created by snowimba on 15/12/13.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LHReTableView;
@interface LHCellScroll : UIScrollView
@property (nonatomic,strong) id cellM;
@property (nonatomic,strong) LHReTableView *tableRe;
@property (nonatomic,strong) NSArray *sortAVs;
@end
