//
//  DanMuModel.h
//  Day09_1_XmlParse
//
//  Created by apple-jd44 on 15/11/12.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "YHCoderObject.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DanMuModel : YHCoderObject
@property (nonatomic, strong) NSNumber* sendTime;
@property (nonatomic, strong) NSNumber* style;
@property (nonatomic, strong) NSNumber* fontSize;
@property (nonatomic, strong) NSNumber* textColor;
@property (nonatomic, strong) NSString* text;

+ (instancetype)modelWithParameter:(NSString*)parameter text:(NSString*)text;
@end
