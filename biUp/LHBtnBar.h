//
//  LHBtnBar.h
//  biUp
//
//  Created by snowimba on 15/12/13.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHBtnBar : UIView
@property (nonatomic, strong) NSArray* titleArr;
@property (nonatomic, copy) void (^clickBtn)(NSInteger);
@property (nonatomic, weak) UIView* bottomView;
- (void)changeBtnColor:(NSInteger)tagNum;
@end
