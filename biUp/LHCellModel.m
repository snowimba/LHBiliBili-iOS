//
//  LHCellModel.m
//  biUp
//
//  Created by snowimba on 15/12/10.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHCellModel.h"
#import "AFAppDotNetAPIClient.h"
@implementation LHCellModel

//+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
//    
//    return [[AFAppDotNetAPIClient sharedClient] GET:@"api.bilibili.com/online_list?_device=android&_hwid=130a7709aeac1793&appkey=c1b107428d337928&platform=android&typeid=13&sign=cb5cf6d54ed92fc25c4a8b4292a46692" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
//        
//        NSArray *postsFromResponse = [NSArray arrayWithArray:[JSON valueForKeyPath:@"list"]];
//        
//        
//        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
//        
//        for (NSDictionary *attributes in postsFromResponse) {
//            LHCellModel *post = [[LHCellModel alloc] initWithDict :attributes];
//            [mutablePosts addObject:post];
//        }
//        
//        if (block) {
//            block([NSArray arrayWithArray:mutablePosts], nil);
//        }
//    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
//        
//        if (block) {
//            
//            block([NSArray array], error);
//            
//        }
//    }];
//}

+ (instancetype)cellMWithDict:(NSDictionary *)dict{

    return [[self alloc] initWithDict:dict];

}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.title = [dict valueForKey:@"title"];
        
        self.small_cover = [ dict valueForKey:@"pic"];
        
        self.param = [dict valueForKey:@"aid"];
        
        self.desc2 = [NSString stringWithFormat:@"UP主:%@",[dict valueForKey:@"author"]];
        
        
        self.danmaku = [dict valueForKey:@"video_review"];
        
        self.play = [dict valueForKey:@"play"];
        
        self.desc1 = [dict valueForKey:@"description"];
        
    }
    return self;
}
@end
