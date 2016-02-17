//
//  LHTaCellM.m
//  biUp
//
//  Created by snowimba on 15/12/13.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHTaCellM.h"
#import "NSString+Tools.h"
@implementation LHTaCellM
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.param = [[dict valueForKey:@"id"]isKindOfClass:[NSString class]]?[dict valueForKey:@"id"]:[NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        self.desc1 = [dict valueForKey:@"description"];
        self.play = [dict valueForKey:@"click"]?[NSString stringWithFormatNum:[[dict valueForKey:@"click"] integerValue]]:[NSString stringWithFormatNum:[[dict valueForKey:@"play"] integerValue]];
        self.danmaku = [dict valueForKey:@"dm_count"]?[NSString stringWithFormat:@"%@",[dict valueForKey:@"dm_count"]]:[NSString stringWithFormat:@"%@",[dict valueForKey:@"favorites"]];
        self.desc2 = [dict valueForKey:@"author_name"]?[NSString stringWithFormat:@"UP主:%@",[dict valueForKey:@"author_name"]]:[NSString stringWithFormat:@"UP主:%@",[dict valueForKey:@"author"]];
        
        self.small_cover = [dict valueForKey:@"pic"];
        
        self.title = [dict valueForKey:@"title"];
        
    }
    return self;
}

+ (instancetype)cellWithDict:(NSDictionary *)dict{

    return [[self alloc] initWithDict:dict];

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
