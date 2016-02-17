//
//  LHShop.m
//  12-自习瀑布流UP2.0
//
//  Created by snowimba on 15/11/26.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHShop.h"

@implementation LHShop

+ (instancetype)shopWithDict:(NSDictionary*)dict
{

    return [[self alloc] initWithDict:dict];

    //    return obj;
}

- (instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {

        [self setValuesForKeysWithDictionary:dict];
        self.isNew = (Boolean)[dict valueForKey:@"new"];
        
        
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString*)key
{
}

@end
