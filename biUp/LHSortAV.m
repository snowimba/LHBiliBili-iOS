//
//  LHSortAV.m
//  biUp
//
//  Created by snowimba on 16/1/11.
//  Copyright © 2016年 snowimba. All rights reserved.
//

#import "LHSortAV.h"

@implementation LHSortAV
+ (instancetype)sortAVWithDict:(NSDictionary *)dict{
    
    id obj = [[self alloc]init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end
