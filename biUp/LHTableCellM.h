//
//  LHTableCellM.h
//  biUp
//
//  Created by snowimba on 15/12/13.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LHTaCellM;
@interface LHTableCellM : UITableViewCell
@property (nonatomic,strong) LHTaCellM *cellM;
+ (instancetype)cellWithTableV:(UITableView *)table;
@end
