//
//  LHParam.m
//  biUp
//
//  Created by snowimba on 15/12/24.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHParam.h"

@implementation LHParam
+ (instancetype)paramWithDict:(NSDictionary*)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        self.param = [dict valueForKey:@"av_id"];
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString*)key
{
}
@end
