//
//  CFDanmakuInfo.h
//  HJDanmakuDemo
//
//  Created by 于 传峰 on 15/7/10.
//  Copyright (c) 2015年 olinone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHCoderObject.h"
@class CFDanmaku;

@interface CFDanmakuInfo : YHCoderObject

// 弹幕内容label
@property(nonatomic, weak) UILabel  *playLabel;
// 弹幕label frame
//@property(nonatomic, assign) CGRect labelFrame;
//
@property(nonatomic, assign) NSTimeInterval leftTime;
@property(nonatomic, strong) CFDanmaku* danmaku;
@property(nonatomic, assign) NSInteger lineCount;

@end
