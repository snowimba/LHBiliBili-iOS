//
//  LHTaCellM.h
//  biUp
//
//  Created by snowimba on 15/12/13.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHCoderObject.h"
@interface LHTaCellM : YHCoderObject
@property (nonatomic, copy) NSString* pic;
//@property (nonatomic, copy) NSString* av;
@property (nonatomic,strong) NSNumber *av;
@property (nonatomic, copy) NSString* title;
//@property (nonatomic, copy) NSString* click;
@property (nonatomic,strong) NSNumber *click;
//@property (nonatomic, copy) NSString* dm_count;
@property (nonatomic,strong) NSNumber *dm_count;
//@property (nonatomic, copy) NSString* scores;
//@property (nonatomic, copy) NSString* stow;
//@property (nonatomic, copy) NSString* duration;
@property (nonatomic, copy) NSString* des;
@property (nonatomic, copy) NSString* author_name;
@property (nonatomic,copy) NSString *collTime;
@property (nonatomic,copy) NSString *hisTime;

@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSString *danmaku;
@property (nonatomic,copy) NSString *desc1;
@property (nonatomic,copy) NSString *desc2;
@property (nonatomic,copy) NSString *play;
@property (nonatomic,copy) NSString *param;
@property (nonatomic,copy) NSString *up_face;
@property (nonatomic,copy) NSString *up;
@property (nonatomic,copy) NSString *online;
@property (nonatomic,copy) NSString *small_cover;

@property (nonatomic,assign) NSInteger rand;

//@property (nonatomic,copy) NSString *des;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)cellWithDict:(NSDictionary *)dict;

@end

////pic	:	http://i2.hdslb.com/video/bc/bcddec4af8ab480e22944ad4bf1ba0ce.jpg
//
//id	:	3068025
//
//title	:	【Bongyoung Park】编舞This Summer\\'s Gonna Hurt Like a MotherFuck
//
//click	:	17004
//
//dm_count	:	139
//
//scores	:	16
//
//stow	:	500
//
//duration	:	1:32
//
//editdate	:	1444996293
//
//pubdate	:	1444995830
//
//typeid	:	154
//
//subtitle	:
//
//description	:	YOUTUBE BGM:This Summer's Gonna Hurt Like a MotherFucker - Maroon 5  高跟鞋妖男回归2333 不再是黑发~原网址:https://www.youtube.com/watch?v=7houYZEz3Js
//
//author_name	:	神奇的FIVE5
