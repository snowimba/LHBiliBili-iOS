//
//  LHNetworkQueue.m
//  ASI下载
//
//  Created by snowimba on 16/1/9.
//  Copyright © 2016年 snowimba. All rights reserved.
//

#import "LHNetworkQueue.h"

@implementation LHNetworkQueue
+ (instancetype)shared
{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ASINetworkQueue alloc] init];

        [_instance reset];

        [_instance setShowAccurateProgress:YES];

        [_instance go];

    });
    return _instance;
}
@end
