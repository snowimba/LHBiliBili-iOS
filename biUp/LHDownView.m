//
//  LHDownView.m
//  biUp
//
//  Created by snowimba on 16/1/7.
//  Copyright © 2016年 snowimba. All rights reserved.
//

#import "LHASIHTTPRequest.h"
#import "LHDescModel.h"
#import "LHDownView.h"
#import "LHNetworkQueue.h"
#import "LHRequestDesc.h"
#import "LHSortAV.h"
#import "LHWebAVPlayer.h"
#import <SystemServices.h>
#define SystemSharedServices [SystemServices sharedServices]

@interface LHButton : UIButton

@end

@implementation LHButton

- (void)setHighlighted:(BOOL)highlighted {}

@end

@interface LHDownView ()
@property (weak, nonatomic) IBOutlet UILabel* numLbl01;

@property (weak, nonatomic) IBOutlet UILabel* numLbl02;
@property (weak, nonatomic) IBOutlet UIScrollView* scrollV;

@property (nonatomic, copy) NSString* destPath;
@property (nonatomic, copy) NSString* tempPath;
@property (weak, nonatomic) IBOutlet UIButton* allDownBtn;
//@property (weak, nonatomic) IBOutlet UIButton* downBtn;
@property (weak, nonatomic) IBOutlet UIButton* pushBtn;
@property (nonatomic, strong) LHNetworkQueue* networkQueue;
@end
@implementation LHDownView

- (LHNetworkQueue*)networkQueue
{

    if (!_networkQueue) {

        _networkQueue = [LHNetworkQueue shared];
    }

    return _networkQueue;
}

- (void)awakeFromNib
{
    self.numLbl01.text = [NSString stringWithFormat:@"已用%@，剩余", [SystemSharedServices usedDiskSpaceinRaw]];
    // Free Disk Space
    self.numLbl02.text = [NSString stringWithFormat:@"%@", [SystemSharedServices freeDiskSpaceinRaw]];
}

- (void)setArrDict:(NSArray*)arrDict
{

    _arrDict = arrDict;

    NSString* cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];

    NSFileManager* fm = [NSFileManager defaultManager];
    CGFloat btnM = 20;
    CGFloat btnW = ([UIScreen mainScreen].bounds.size.width - 3 * btnM) * 0.5;

    self.scrollV.showsVerticalScrollIndicator = NO;

    self.scrollV.contentSize = CGSizeMake(0, (((arrDict.count) / 2 + 1) * (12 + 30)));

    for (NSInteger i = 0; i < arrDict.count; i++) {

        UIButton* btn = [[UIButton alloc] init];

        [self.scrollV addSubview:btn];

        btn.frame = CGRectMake(12 + (30 + btnW) * (i % 2), 12 + (12 + 30) * (i / 2), btnW, 30);

        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);

        btn.imageEdgeInsets = UIEdgeInsetsMake(20, btn.bounds.size.width - 10, 0, 0);

        [btn setTitle:[arrDict[i] Title] forState:UIControlStateNormal];

        btn.titleLabel.font = [UIFont boldSystemFontOfSize:10.0];

        btn.backgroundColor = [UIColor whiteColor];

        btn.titleLabel.numberOfLines = 2;

        [btn setTitleColor:[UIColor colorWithRed:240 / 255.0 green:102 / 255.0 blue:144 / 255.0 alpha:1] forState:UIControlStateNormal];

        btn.layer.cornerRadius = 3;

        btn.clipsToBounds = YES;

        btn.tag = i;

        // -----------------------------------------------------------

        NSString* destFilePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", [arrDict[i] CID]]];

        NSString* tempFilePath = [destFilePath stringByAppendingString:@".temp"];

        if ([fm fileExistsAtPath:destFilePath]) {

            self.allDownBtn.enabled = NO;

            [btn setImage:[UIImage imageNamed:@"ic_checkbox_pink_selected2"] forState:UIControlStateDisabled];

            btn.enabled = NO;
            self.pushBtn.selected = YES;
        }
        if ([fm fileExistsAtPath:tempFilePath]) {

            self.allDownBtn.enabled = NO;

            [btn setImage:[UIImage imageNamed:@"badge_download_inprogress"] forState:UIControlStateDisabled];
            btn.enabled = NO;
            self.pushBtn.selected = YES;

            //        self.downBtn.userInteractionEnabled = NO;
        }

        if (![fm fileExistsAtPath:destFilePath] && ![fm fileExistsAtPath:tempFilePath]) {
            self.allDownBtn.enabled = YES;
            btn.enabled = YES;
            self.pushBtn.selected = NO;
        }

        [btn addTarget:self action:@selector(downStarBtn:) forControlEvents:UIControlEventTouchUpInside];
    }

    NSString* list = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"list.data"];
    if (![fm fileExistsAtPath:list]) {

        NSMutableArray* arrM = [NSMutableArray array];

        [NSKeyedArchiver archiveRootObject:arrM toFile:list];
    }
}

//- (void)setCellM:(id)cellM
//{
//
//    _cellM = cellM;
//
//    NSString* cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//
//    NSString* destFilePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", [self.cellM param]]];
//
//    NSString* tempFilePath = [destFilePath stringByAppendingString:@".temp"];
//    self.tempPath = tempFilePath;
//    self.destPath = destFilePath;
//
//    NSFileManager* fm = [NSFileManager defaultManager];
//
//    if ([fm fileExistsAtPath:destFilePath]) {
//
//        self.allDownBtn.enabled = NO;
//
//        [self.downBtn setImage:[UIImage imageNamed:@"ic_checkbox_pink_selected2"] forState:UIControlStateDisabled];
//
//        self.downBtn.enabled = NO;
//        self.pushBtn.selected = YES;
//    }
//    if ([fm fileExistsAtPath:tempFilePath]) {
//
//        self.allDownBtn.enabled = NO;
//
//        [self.downBtn setImage:[UIImage imageNamed:@"badge_download_inprogress"] forState:UIControlStateDisabled];
//        self.downBtn.enabled = NO;
//        self.pushBtn.selected = YES;
//
//        //        self.downBtn.userInteractionEnabled = NO;
//    }
//
//    if (![fm fileExistsAtPath:destFilePath]&&![fm fileExistsAtPath:tempFilePath]) {
//        self.allDownBtn.enabled = YES;
//        self.downBtn.enabled = YES;
//        self.pushBtn.selected = NO;
//    }
//
//    NSString* list = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"list.data"];
//    if (![fm fileExistsAtPath:list]) {
//
//        NSMutableArray* arrM = [NSMutableArray array];
//
//        [NSKeyedArchiver archiveRootObject:arrM toFile:list];
//    }
//}

- (IBAction)pushDownVC:(UIButton*)sender
{
    if (self.pushBlock) {
        self.pushBlock();
    }
}
- (IBAction)backBtn:(id)sender
{

    [UIView animateWithDuration:0.5 animations:^{

        self.transform = CGAffineTransformMakeTranslation(0, 0);

    }];
}

- (void)downStarBtn:(UIButton*)sender
{

    self.allDownBtn.enabled = NO;

    [sender setImage:[UIImage imageNamed:@"badge_download_inprogress"] forState:UIControlStateDisabled];

    sender.enabled = NO;

    self.pushBtn.selected = YES;

    NSString* cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //
    NSString* destFilePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", [self.arrDict[sender.tag] CID]]];

    NSString* tempFilePath = [destFilePath stringByAppendingString:@".temp"];

    if ([self.arrDict[sender.tag] Mp4Url] == nil) {

        [LHWebAVPlayer getPlayerURL:self.arrDict[sender.tag] backBlock:^(NSArray* arr) {

            NSURL* string_URL = [NSURL URLWithString:[arr firstObject]];

            //2.创建一个对象
            LHASIHTTPRequest* request = [LHASIHTTPRequest requestWithURL:string_URL];

            //2.1 设置你下载完成之后的路径
            request.downloadDestinationPath = destFilePath;

            //2.2 设置临时的文件路径,没有下载完成,就是这个临时文件路径
            request.temporaryFileDownloadPath = tempFilePath;

            //2.3 允许断点续传
            request.allowResumeForFileDownloads = YES;

            //2.4 允许后台下载
            request.shouldContinueWhenAppEntersBackground = YES;

            //2.5设置Key
            request.request_Key = [NSString stringWithFormat:@"%@", [self.arrDict[sender.tag] CID]];

            //3.下载
            [self.networkQueue addOperation:request];

            NSString* list = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"list.data"];
            LHRequestDesc* requestDesc = [[LHRequestDesc alloc] init];
            requestDesc.key = [NSString stringWithFormat:@"%@", [self.arrDict[sender.tag] CID]];
            requestDesc.titel = [NSString stringWithFormat:@"%@", [self.arrDict[sender.tag] Title]];
            requestDesc.URL = string_URL.absoluteString;
            requestDesc.tag_Btn = @1;
            requestDesc.cellM = self.cellM;
            requestDesc.danmuku = [NSString stringWithFormat:@"%@", [self.arrDict[sender.tag] CID]];
            NSMutableArray* arrM = [NSKeyedUnarchiver unarchiveObjectWithFile:list];
            [arrM addObject:requestDesc];
            [NSKeyedArchiver archiveRootObject:arrM toFile:list];


        }];
        return;
    }

    NSURL* string_URL = [NSURL URLWithString:[self.arrDict[sender.tag] Mp4Url]];

    //2.创建一个对象
    LHASIHTTPRequest* request = [LHASIHTTPRequest requestWithURL:string_URL];

    //2.1 设置你下载完成之后的路径
    request.downloadDestinationPath = destFilePath;

    //2.2 设置临时的文件路径,没有下载完成,就是这个临时文件路径
    request.temporaryFileDownloadPath = tempFilePath;

    //2.3 允许断点续传
    request.allowResumeForFileDownloads = YES;

    //2.4 允许后台下载
    request.shouldContinueWhenAppEntersBackground = YES;

    //2.5设置Key
    request.request_Key = [NSString stringWithFormat:@"%@", [self.arrDict[sender.tag] CID]];

    //3.下载
    [self.networkQueue addOperation:request];

    NSString* list = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"list.data"];
    LHRequestDesc* requestDesc = [[LHRequestDesc alloc] init];
    requestDesc.key = [NSString stringWithFormat:@"%@", [self.arrDict[sender.tag] CID]];
    requestDesc.titel = [NSString stringWithFormat:@"%@", [self.arrDict[sender.tag] Title]];
    requestDesc.URL = string_URL.absoluteString;
    requestDesc.tag_Btn = @1;
    requestDesc.cellM = self.cellM;
    requestDesc.danmuku = [NSString stringWithFormat:@"%@", [self.arrDict[sender.tag] CID]];
    NSMutableArray* arrM = [NSKeyedUnarchiver unarchiveObjectWithFile:list];
    [arrM addObject:requestDesc];
    [NSKeyedArchiver archiveRootObject:arrM toFile:list];
}

+ (instancetype)downLoadView
{

    return [[[NSBundle mainBundle] loadNibNamed:@"LHDownView" owner:nil options:nil] lastObject];
}

@end
