//
//  LHDescModel.m
//  biUp
//
//  Created by snowimba on 15/12/12.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHDescModel.h"

@implementation LHDescModel
+ (instancetype)cellMWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
