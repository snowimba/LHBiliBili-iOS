//
//  LHFaheadModel.h
//  biUp
//
//  Created by snowimba on 15/12/11.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHFaheadModel : NSObject
@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSString *keyword;
- (instancetype)initWithDict:(NSDictionary *)dict;

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block;
@end
