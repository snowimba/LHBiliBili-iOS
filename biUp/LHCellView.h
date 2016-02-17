//
//  LHCellView.h
//  biUp
//
//  Created by snowimba on 15/12/10.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LHCellModel;
@interface LHCellView : UIView
@property (nonatomic,strong) LHCellModel *cellM;
+ (instancetype)viewWithNib;
@end
