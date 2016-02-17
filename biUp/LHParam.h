//
//  LHParam.h
//  biUp
//
//  Created by snowimba on 15/12/24.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHParam : NSObject
@property (nonatomic,copy) NSString *param;
@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSString *danmaku;
@property (nonatomic,copy) NSString *update_time;
@property (nonatomic,copy) NSString *index;
+ (instancetype)paramWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
