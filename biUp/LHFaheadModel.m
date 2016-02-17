//
//  LHFaheadModel.m
//  biUp
//
//  Created by snowimba on 15/12/11.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHFaheadModel.h"
#import "AFAppDotNetAPIClient.h"
@implementation LHFaheadModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.keyword = [dict valueForKey:@"keyword"];
        
        self.cover = [dict valueForKey:@"cover"];
    }
    return self;
}

+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    
   return [[AFAppDotNetAPIClient sharedClient] GET:@"api/search/5391/search.android.xxhdpi.android.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *arrD = [responseObject valueForKeyPath:@"result"];
        
        //        NSDictionary *dict = arr[0];
        
        NSArray *postsFromResponse = [arrD valueForKeyPath:@"recommend"];
        //        NSLog(@"%@",postsFromResponse);
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        
        for (NSDictionary *attributes in postsFromResponse) {
            LHFaheadModel *post = [[LHFaheadModel alloc] initWithDict :attributes];
            [mutablePosts addObject:post];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block) {
            
            block([NSArray array], error);
            
        }
    }];
    
//    return [[AFAppDotNetAPIClient sharedClient] GET:@"api/search/5391/search.android.xxhdpi.android.json" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
//        
//        NSDictionary *arrD = [JSON valueForKeyPath:@"result"];
//       
////        NSDictionary *dict = arr[0];
//        
//        NSArray *postsFromResponse = [arrD valueForKeyPath:@"recommend"];
////        NSLog(@"%@",postsFromResponse);
//        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
//        
//        for (NSDictionary *attributes in postsFromResponse) {
//            LHFaheadModel *post = [[LHFaheadModel alloc] initWithDict :attributes];
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
}

@end
