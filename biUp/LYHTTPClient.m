//
//  LYHTTPClient.m
//  LYHttpClient
//
//  Created by lichangwen on 15/12/28.
//  Copyright © 2015年 LianLeven. All rights reserved.
//

#import "LYHTTPClient.h"
#import <YYCache/YYCache.h>
#import "NSJSONSerialization+LYJSON.h"
static NSString * const LYHTTPClientURLString = @"https://api.app.net/";
static NSString * const LYHTTPClientRequestCache = @"LYHTTPClientRequestCache";
typedef NS_ENUM(NSUInteger, LYHTTPClientRequestType) {
    LYHTTPClientRequestTypeGET = 0,
    LYHTTPClientRequestTypePOST,
};
@implementation LYHTTPClient

#pragma mark - public
//优先使用缓存
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    return [self requestMethod:LYHTTPClientRequestTypeGET urlString:URLString parameters:parameters cachePolicy:LYHTTPClientReturnCacheDataThenLoad success:success failure:failure];
}
+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                  cachePolicy:(LYHTTPClientRequestCachePolicy)cachePolicy
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    return [self requestMethod:LYHTTPClientRequestTypeGET urlString:URLString parameters:parameters cachePolicy:cachePolicy success:success failure:failure];
}
//优先使用缓存
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    return [self requestMethod:LYHTTPClientRequestTypePOST urlString:URLString parameters:parameters cachePolicy:LYHTTPClientReturnCacheDataThenLoad success:success failure:failure];
}
+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                   parameters:(id)parameters
                  cachePolicy:(LYHTTPClientRequestCachePolicy)cachePolicy
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    return [self requestMethod:LYHTTPClientRequestTypePOST urlString:URLString parameters:parameters cachePolicy:cachePolicy success:success failure:failure];
}

#pragma mark - private
+ (NSURLSessionDataTask *)requestMethod:(LYHTTPClientRequestType)type
                              urlString:(NSString *)URLString
                             parameters:(id)parameters
                            cachePolicy:(LYHTTPClientRequestCachePolicy)cachePolicy
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    NSString *cacheKey = URLString;
    if (parameters) {
        if (![NSJSONSerialization isValidJSONObject:parameters]) return nil;//参数不是json类型
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        NSString *paramStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        cacheKey = [URLString stringByAppendingString:paramStr];
    }
    
    YYCache *cache = [[YYCache alloc] initWithName:LYHTTPClientRequestCache];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    
   
    
    id object = [cache objectForKey:cacheKey];
    
    
    switch (cachePolicy) {
        case LYHTTPClientReturnCacheDataThenLoad: {//先返回缓存，同时请求
            if (object) {
                success(nil,object);
            }
            break;
        }
        case LYHTTPClientReloadIgnoringLocalCacheData: {//忽略本地缓存直接请求
            //不做处理，直接请求
            break;
        }
        case LYHTTPClientReturnCacheDataElseLoad: {//有缓存就返回缓存，没有就请求
            if (object) {//有缓存
                success(nil,object);
                return nil;
            }
            break;
        }
        case LYHTTPClientReturnCacheDataDontLoad: {//有缓存就返回缓存,从不请求（用于没有网络）
            if (object) {//有缓存
                success(nil,object);
                
            }
            return nil;//退出从不请求
        }
        default: {
            break;
        }
    }
    return [self requestMethod:type urlString:URLString parameters:parameters cache:cache cacheKey:cacheKey success:success failure:failure];
    
}
+ (NSURLSessionDataTask *)requestMethod:(LYHTTPClientRequestType)type
                              urlString:(NSString *)URLString
                             parameters:(id)parameters
                                  cache:(YYCache *)cache
                               cacheKey:(NSString *)cacheKey
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    switch (type) {
        case LYHTTPClientRequestTypeGET:{
            
            return [[LYHTTPClient sharedClient] GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSData class]]) {
                    responseObject = [NSJSONSerialization objectWithJSONData:responseObject];
                }
                [cache setObject:responseObject forKey:cacheKey];//YYCache 已经做了responseObject为空处理
                success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(task, error);
            }];
            break;
        }
        case LYHTTPClientRequestTypePOST:{
            return [[LYHTTPClient sharedClient] POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                if ([responseObject isKindOfClass:[NSData class]]) {
                    responseObject = [NSJSONSerialization objectWithJSONData:responseObject];
                }
                [cache setObject:responseObject forKey:cacheKey];//YYCache 已经做了responseObject为空处理
                success(task,responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(task, error);
            }];
            break;
        }
        default:
            break;
    }
    
}
/// URLString 应该是全url 上传单个文件
+ (NSURLSessionUploadTask *)upload:(NSString *)URLString filePath:(NSString *)filePath parameters:(id)parameters{
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSURLSessionUploadTask *uploadTask = [[LYHTTPClient client] uploadTaskWithRequest:request fromFile:fileUrl progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
    return uploadTask;
}
+ (instancetype)sharedClient{
    static LYHTTPClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [LYHTTPClient client];
        
    });
    return sharedClient;
}
+ (instancetype)client{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
   return [[LYHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:LYHTTPClientURLString] sessionConfiguration:configuration];
}
@end
