//
//  LHWebAVPlayer.m
//  biUp
//
//  Created by snowimba on 15/12/26.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "AFNetworking.h"
#import "DanMuModel.h"
#import "LHRequestDesc.h"
#import "LHSortAV.h"
#import "LHWebAVPlayer.h"
#import "UIKit+AFNetworking.h"
#import "XML2Dic.h"
#define PATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"list.data"]
@interface LHWebAVPlayer ()
@property (nonatomic, strong) NSMutableArray* arrDict;
@property (nonatomic, strong) LHRequestDesc* requestDesc;
@end
@implementation LHWebAVPlayer

- (NSMutableArray*)arrDict
{

    if (!_arrDict) {
        _arrDict = [NSMutableArray array];
    }

    return _arrDict;
}
- (void)setParam:(NSString*)param
{

    _param = param;

    NSFileManager* fm = [NSFileManager defaultManager];

    if ([fm fileExistsAtPath:PATH]) {

        NSMutableArray* arrM = [NSKeyedUnarchiver unarchiveObjectWithFile:PATH];

        for (LHRequestDesc* reDesc in arrM) {

            if ([reDesc.key isEqualToString:param]) {
                self.requestDesc = reDesc;
                break;
            }
        }
        if (self.requestDesc != nil) {

            NSString* destFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", param]];
            NSURL* urlLocal = [[NSURL alloc] initFileURLWithPath:destFilePath];

            [self.arrDict addObject:urlLocal.absoluteString];

            [self.arrDict addObject:_requestDesc.danmuku];

            if (self.AVPlayer) {

                self.AVPlayer(self.arrDict);
            }

            return;
        }
    }

    NSURL* URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.bilibilijj.com/Api/AvToCid/%@", param]];

    NSURLRequest* req = [NSURLRequest requestWithURL:URL];

    UIWebView* web = [[UIWebView alloc] init];
    NSProgress* progress = nil;
    [web loadRequest:req progress:&progress success:^NSString* _Nonnull(NSHTTPURLResponse* _Nonnull response, NSString* _Nonnull HTML) {

        if (HTML != nil) {

            //                NSMutableString* str = [NSMutableString stringWithString:HTML];

            NSData* d = [HTML dataUsingEncoding:NSUTF8StringEncoding];

            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];

            NSArray* arr01 = [NSArray arrayWithArray:[dict valueForKey:@"list"]];

            //            NSLog(@"%@",dict);
            for (NSDictionary* dict in arr01) {
                [self getAVURL:[dict valueForKey:@"CID"]];
            }
        }
        return HTML;
    }
        failure:^(NSError* _Nonnull error){
        }];

    //    _____________________
}

+ (void)getDownLoadURLToSortAV:(NSString*)param backBlock:(PlayerBlock)player
{
    NSURL* URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.bilibilijj.com/Api/AvToCid/%@", param]];

    NSURLRequest* req = [NSURLRequest requestWithURL:URL];

    UIWebView* web = [[UIWebView alloc] init];
    NSProgress* progress = nil;
    [web loadRequest:req progress:&progress success:^NSString* _Nonnull(NSHTTPURLResponse* _Nonnull response, NSString* _Nonnull HTML) {

        if (HTML != nil) {

            NSData* d = [HTML dataUsingEncoding:NSUTF8StringEncoding];

            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];

            NSString* desc = [dict valueForKey:@"desc"];

            NSString* up = [dict valueForKey:@"up"];

            NSArray* arr01 = [NSArray arrayWithArray:[dict valueForKey:@"list"]];

            NSMutableArray* arrM = [NSMutableArray arrayWithCapacity:arr01.count];
            for (NSDictionary* dict in arr01) {
                LHSortAV* sortAV = [LHSortAV sortAVWithDict:dict];
                [arrM addObject:sortAV];
            }

            if (player) {
                player(arrM, desc, up);
            }
        }
        return HTML;
    }
        failure:^(NSError* _Nonnull error){
        }];
}

+ (void)getPlayerURL:(LHSortAV*)sotr backBlock:(PlayerURLBlock)URLArr
{

    NSFileManager* fm = [NSFileManager defaultManager];

    if ([fm fileExistsAtPath:PATH]) {

        NSMutableArray* arrM = [NSKeyedUnarchiver unarchiveObjectWithFile:PATH];

        LHRequestDesc* requestDesc = nil;

        for (LHRequestDesc* reDesc in arrM) {

            if ([reDesc.key isEqualToString:[NSString stringWithFormat:@"%@", sotr.CID]]) {
                requestDesc = reDesc;
                break;
            }
        }
        if (requestDesc != nil) {

            NSString* destFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", [NSString stringWithFormat:@"%@", sotr.CID]]];
            NSURL* urlLocal = [[NSURL alloc] initFileURLWithPath:destFilePath];

            NSMutableArray* arrGo = [NSMutableArray arrayWithCapacity:2];

            [arrGo addObject:urlLocal.absoluteString];

            [arrGo addObject:sotr.CID];

            if (URLArr) {

                URLArr(arrGo);
            }

            return;
        }
    }

    NSString* vpath = [NSString stringWithFormat:@"http://interface.bilibili.com/playurl?platform=android&_device=android&_hwid=831fc7511fa9aff5&_tid=0&_p=1&_down=0&quality=3&otype=json&appkey=86385cdc024c0f6c&type=mp4&sign=7fed8a9b7b446de4369936b6c1c40c3f&_aid=%@&cid=%@", sotr.AV, sotr.CID];

    //    NSLog(@"%@", vpath);
    NSURL* URL = [NSURL URLWithString:vpath];

    NSURLRequest* req = [NSURLRequest requestWithURL:URL];

    UIWebView* web = [[UIWebView alloc] init];
    NSProgress* progress = nil;
    [web loadRequest:req progress:&progress success:^NSString* _Nonnull(NSHTTPURLResponse* _Nonnull response, NSString* _Nonnull HTML) {

        if (HTML.length > 0) {

            //                NSMutableString* str = [NSMutableString stringWithString:HTML];

            NSData* d = [HTML dataUsingEncoding:NSUTF8StringEncoding];

            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];

            NSArray* arr01 = [NSArray arrayWithArray:[dict valueForKey:@"durl"]];

            //            NSLog(@"%@",dict);

            NSArray* arr02 = [NSArray arrayWithArray:[dict valueForKey:@"backup_url"]];

            NSString* url = [[arr01 firstObject] valueForKey:@"url"] ? [[arr01 firstObject] valueForKey:@"url"] : [arr02 firstObject];

            NSMutableArray* arrM = [NSMutableArray arrayWithCapacity:2];

            [arrM addObject:url ? url : @""];

            [arrM addObject:sotr.CID ? sotr.CID : @""];

            if (URLArr) {

                URLArr(arrM);
            }
        }
        return HTML;
    }
        failure:^(NSError* _Nonnull error){
        }];
}

//- (void)setDanmaku:(NSString*)danmaku
//{
//
//    _danmaku = danmaku;
//    NSURL* URLD = [NSURL URLWithString:[NSString stringWithFormat:@"http://comment.bilibili.com/%@.xml", danmaku]];
//    //    NSLog(@"%@",URLD);
//    //http://comment.bilibili.com/5469241.xml
//    //    NSLog(@"%@",URLD);
//    NSURLRequest* reqD = [NSURLRequest requestWithURL:URLD];
//
//    UIWebView* webD = [[UIWebView alloc] init];
//
//    [webD loadRequest:reqD progress:nil success:^NSString* _Nonnull(NSHTTPURLResponse* _Nonnull response, NSString* _Nonnull HTML) {
//
//            if (HTML != nil) {
//
//                NSDictionary* dict = [XML2Dic dicWithData:HTML];
//
//                if (self.SpAVPlayer) {
//
//                    self.SpAVPlayer(dict);
//                }
//            }
//            return HTML;
//        }
//
//        failure:^(NSError* _Nonnull error){
//        }];
//}

- (void)getAVURL:(NSString*)CID
{

    NSString* vpath = [NSString stringWithFormat:@"http://interface.bilibili.com/playurl?platform=android&_device=android&_hwid=831fc7511fa9aff5&_tid=0&_p=1&_down=0&quality=3&otype=json&appkey=86385cdc024c0f6c&type=mp4&sign=7fed8a9b7b446de4369936b6c1c40c3f&_aid=%@&cid=%@", self.param, CID];

    //    NSLog(@"%@", vpath);
    NSURL* URL = [NSURL URLWithString:vpath];

    NSURLRequest* req = [NSURLRequest requestWithURL:URL];

    UIWebView* web = [[UIWebView alloc] init];
    NSProgress* progress = nil;
    [web loadRequest:req progress:&progress success:^NSString* _Nonnull(NSHTTPURLResponse* _Nonnull response, NSString* _Nonnull HTML) {

        if (HTML.length > 0) {

            //                NSMutableString* str = [NSMutableString stringWithString:HTML];

            NSData* d = [HTML dataUsingEncoding:NSUTF8StringEncoding];

            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];

            NSArray* arr01 = [NSArray arrayWithArray:[dict valueForKey:@"durl"]];

            //            NSLog(@"%@",dict);

            NSArray* arr02 = [NSArray arrayWithArray:[dict valueForKey:@"backup_url"]];

            NSString* url = arr02.count ? [arr02 firstObject] : ([[arr01 firstObject] valueForKey:@"url"] ? [[arr01 firstObject] valueForKey:@"url"] : @"");

            [self.arrDict addObject:url];

            [self.arrDict addObject:CID];

            if (self.AVPlayer) {

                self.AVPlayer(self.arrDict);
            }
        }
        return HTML;
    }
        failure:^(NSError* _Nonnull error){
        }];
}

@end
