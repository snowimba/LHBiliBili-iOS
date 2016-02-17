//
//  LHShop.h
//  12-自习瀑布流UP2.0
//
//  Created by snowimba on 15/11/26.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHShop : NSObject
//@property (nonatomic,assign) CGFloat width;
//@property (nonatomic,assign) CGFloat height;
@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) NSInteger play_count;
@property (nonatomic,assign) NSInteger danmaku_count;
@property (nonatomic,assign) NSInteger season_id;
@property (nonatomic,assign) NSInteger weekday;
@property (nonatomic,copy) NSString *bgmcount;
@property (nonatomic,assign) NSInteger is_finish;
@property (nonatomic,assign) Boolean isNew;

//+(instancetype)shopWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)shopWithDict:(NSDictionary *)dict;
@end
