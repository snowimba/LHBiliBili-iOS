//
//  LHSlideView.h
//  biUp
//
//  Created by snowimba on 15/12/6.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHSlideView : UIView
@property (nonatomic,strong) UIView *shadeView;
@property (nonatomic,copy) void(^showSlide)();
@property (nonatomic,copy) void(^pushBlock)(UIViewController*);
+ (instancetype)slideViewWith;
@end
