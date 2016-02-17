//
//  LHView.h
//  testWeb
//
//  Created by snowimba on 15/12/10.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LHDescModel;
@interface LHDescView : UIView
@property (nonatomic, strong) LHDescModel* testM;
@property (nonatomic, copy) void (^btnClickWith)(LHDescModel*);
//@property (nonatomic,strong) NSArray *arrDict;
+ (instancetype)viewWithNib;
@end
