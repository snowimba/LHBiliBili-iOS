//
//  LHCommM.m
//  biUp
//
//  Created by snowimba on 15/12/22.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHCommM.h"

@implementation LHCommM
+ (instancetype)cellWithDict:(NSDictionary *)dict{
    
    id obj = [[self alloc]init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
