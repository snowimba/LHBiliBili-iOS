//
//  LHDescModel.h
//  biUp
//
//  Created by snowimba on 15/12/12.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHCoderObject.h"
@interface LHDescModel : YHCoderObject
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* cover;
@property (nonatomic,copy) NSString *danmaku;
//@property (nonatomic, strong) NSNumber* danmaku;
@property (nonatomic, copy) NSString* desc1;
@property (nonatomic, copy) NSString* desc2;
@property (nonatomic, copy) NSString* play;
//@property (nonatomic, strong) NSNumber* play;
@property (nonatomic, copy) NSString* param;
@property (nonatomic, copy) NSString* up_face;
@property (nonatomic, copy) NSString* up;
@property (nonatomic, copy) NSString* online;
//@property (nonatomic, strong) NSNumber* online;
@property (nonatomic, copy) NSString* small_cover;
@property (nonatomic, assign) NSInteger rand;
@property (nonatomic,copy) NSString *collTime;
@property (nonatomic,copy) NSString *hisTime;

- (instancetype)initWithDict:(NSDictionary*)dict;
+ (instancetype)cellMWithDict:(NSDictionary*)dict;
@end
