//
//  LHCellBus.h
//  biUp
//
//  Created by snowimba on 15/12/24.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHCellBus : UITableViewCell

@property (nonatomic,strong) NSDictionary *dict;
+ (instancetype)cellWithTableV:(UITableView *)table;
@end
