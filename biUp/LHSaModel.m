//
//  LHSaModel.m
//  biUp
//
//  Created by snowimba on 15/12/7.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHSaModel.h"

@implementation LHSaModel
+ (instancetype)saCellWithDict:(NSDictionary *)dict{
    
    id obj = [[self alloc]init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}
@end
