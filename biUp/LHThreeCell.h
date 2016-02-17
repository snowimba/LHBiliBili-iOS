//
//  LHThreeCell.h
//  biUp
//
//  Created by snowimba on 15/12/25.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LHSpModel;
@interface LHThreeCell : UIView
@property (nonatomic,strong) LHSpModel *cellM;
+ (instancetype)cellWithTableV;
@end
