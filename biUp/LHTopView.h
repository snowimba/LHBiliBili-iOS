//
//  LHTopView.h
//  biUp
//
//  Created by snowimba on 15/12/5.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHTopView : UIView
@property (nonatomic, strong) NSArray* titleArr;
@property (nonatomic, copy) void (^clickBtn)(NSInteger);
@property (nonatomic, copy) void (^clickSlideBtn)();
@property (nonatomic, weak) UIView* bottomView;
- (void)changeBtnColor:(NSInteger)tagNum;
@end
