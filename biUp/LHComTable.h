//
//  LHComTable.h
//  biUp
//
//  Created by snowimba on 15/12/19.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHComTable : UIView
@property (nonatomic,strong) id cellM;
@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) NSArray* arrDict;
@property (nonatomic, strong) NSMutableArray* arrDict02;

- (void)webDataRequest:(NSString*)param;
@end
