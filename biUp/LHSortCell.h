//
//  LHSortCell.h
//  biUp
//
//  Created by snowimba on 16/1/11.
//  Copyright © 2016年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHSortCell : UITableViewCell
@property (nonatomic,strong) NSArray *arrDict;
@property (nonatomic,strong) id cellM;
+ (instancetype)cellWithTableV:(UITableView*)table;
@end
