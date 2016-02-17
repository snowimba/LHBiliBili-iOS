//
//  LHSpModel.m
//  biUp
//
//  Created by snowimba on 15/12/24.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHSpModel.h"

@implementation LHSpModel

+ (instancetype)spMWithDict:(NSDictionary *)dict{
    
    id obj = [[self alloc]init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}




- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
