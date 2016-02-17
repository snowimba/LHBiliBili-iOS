//
//  LHCommCell.h
//  biUp
//
//  Created by snowimba on 15/12/22.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LHCommMH;
@interface LHCommCell : UITableViewCell
@property (nonatomic, strong) LHCommMH* cellM;
@property (nonatomic, assign) CGFloat cellH;
+ (instancetype)cellWithTableV:(UITableView*)table;
@end
