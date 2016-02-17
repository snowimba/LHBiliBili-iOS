//
//  LHDownCell.m
//  biUp
//
//  Created by snowimba on 16/1/9.
//  Copyright © 2016年 snowimba. All rights reserved.
//

#import "LHASIHTTPRequest.h"
#import "LHDescModel.h"
#import "LHDownCell.h"
#import "LHNetworkQueue.h"
#import "LHRequestDesc.h"
#define PATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"list.data"]
@interface LHDownCell () <ASIProgressDelegate>

@property (weak, nonatomic) IBOutlet UIButton* downBtn;

@property (weak, nonatomic) IBOutlet UIProgressView* progView;
@property (weak, nonatomic) IBOutlet UILabel* progLbl;
@property (nonatomic, copy) NSString* URLString;
@property (nonatomic, assign) NSInteger tag_file;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString* destPath;
@property (nonatomic, copy) NSString* tempPath;

@property (nonatomic, strong) LHNetworkQueue* networkQueue;
@end

@implementation LHDownCell

- (LHNetworkQueue*)networkQueue
{

    if (!_networkQueue) {

        _networkQueue = [LHNetworkQueue shared];
    }

    return _networkQueue;
}

- (void)awakeFromNib
{
    // Initialization code
    self.progLbl.hidden = YES;
    
}
- (IBAction)seleAction:(UIButton*)sender
{

    sender.selected = !sender.selected;

    if (sender.selected == YES) {
        if (self.deleBlock) {
            self.deleBlock(self.requestDesc);
        }
    }
    else {

        if (self.deleBlock) {
            self.deleBlock(nil);
        }
    }
}

- (void)setRequestDesc:(LHRequestDesc*)requestDesc
{

    _requestDesc = requestDesc;
    
    self.seleBtn.selected = NO;
    self.progView.progress = self.requestDesc.progressNum?[self.requestDesc.progressNum floatValue]:0;
    
    NSString* cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString* destFilePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", [requestDesc key]]];
    
    NSString* tempFilePath = [destFilePath stringByAppendingString:@".temp"];
    self.tempPath = tempFilePath;
    self.destPath = destFilePath;

    self.requestDesc.destPath = destFilePath;
    self.requestDesc.tempPath = tempFilePath;
    
    self.URLString = requestDesc.URL;

    self.tag_file = [requestDesc.tag_Btn integerValue];

    NSFileManager* fm = [NSFileManager defaultManager];

    if ([fm fileExistsAtPath:self.destPath]) {

        self.tag_file = 3;
        self.progLbl.hidden = NO;
        self.progView.hidden = YES;
        self.progLbl.text = @"已下载";
    }
    if ([fm fileExistsAtPath:self.tempPath]) {

        self.progView.hidden = NO;
        self.progLbl.hidden = YES;
    }

    if (self.tag_file == 1) {

        if (!self.request.inProgress) {

            self.downBtn.tag = 2;

            [self downAction:self.downBtn];
        }
        else {

            //2.5 设置代理
            self.request.downloadProgressDelegate = self;

            self.downBtn.tag = self.tag_file;

            [self.downBtn setImage:[UIImage imageNamed:@"ic_action_download_pause"] forState:UIControlStateNormal];
        }
    }
    else if (self.tag_file == 2) {

        self.downBtn.tag = self.tag_file;

        [self.downBtn setImage:[UIImage imageNamed:@"ic_action_download_start"] forState:UIControlStateNormal];
    }
    else if (self.tag_file == 3) {

        [self.downBtn setImage:[UIImage imageNamed:@"ic_action_download_play"] forState:UIControlStateNormal];
        self.downBtn.tag = self.tag_file;
        self.requestDesc.tag_Btn = @3;
    }
}

#pragma mark - 下载的代理
- (void)setProgress:(float)newProgress
{

    if (newProgress == 1) {

        self.progLbl.hidden = NO;
        self.progView.hidden = YES;
        self.progLbl.text = @"已下载";
        [self.downBtn setImage:[UIImage imageNamed:@"ic_action_download_play"] forState:UIControlStateNormal];
        self.downBtn.tag = 3;
        self.requestDesc.tag_Btn = @3;
    }
    else {

//        self.progLbl.hidden = YES;
//
//        self.progView.hidden = NO;
        self.requestDesc.progressNum = @(newProgress);

        self.progView.progress = newProgress;
    }
}

- (IBAction)downAction:(UIButton*)sender
{
    //    if (_request.inProgress) return;

    if (sender.tag == 1) {

        [self.request clearDelegatesAndCancel];
        self.request = nil;
        [self.downBtn setImage:[UIImage imageNamed:@"ic_action_download_start"] forState:UIControlStateNormal];
        self.downBtn.tag = 2;
        self.requestDesc.tag_Btn = @2;

        return;
    }
    else if (sender.tag == 2) {

        if (_request.inProgress)
            return;
        //2.创建一个对象
        _request = [LHASIHTTPRequest requestWithURL:[NSURL URLWithString:self.URLString]];

        //2.1 设置你下载完成之后的路径
        self.request.downloadDestinationPath = self.destPath;

        //2.2 设置临时的文件路径,没有下载完成,就是这个临时文件路径
        self.request.temporaryFileDownloadPath = self.tempPath;

        //2.3 允许断点续传
        self.request.allowResumeForFileDownloads = YES;

        //2.5 设置代理
        self.request.downloadProgressDelegate = self;

        //2.4 允许后台下载
        self.request.shouldContinueWhenAppEntersBackground = YES;

        self.request.request_Key = self.requestDesc.key;
        //3.下载
        [self.networkQueue addOperation:self.request];

        self.downBtn.tag = 1;
        self.requestDesc.tag_Btn = @1;

        [self.downBtn setImage:[UIImage imageNamed:@"ic_action_download_pause"] forState:UIControlStateNormal];

        return;
    }
    else if (sender.tag == 3) {

        NSFileManager* fm = [NSFileManager defaultManager];

        if ([fm fileExistsAtPath:self.destPath]) {

            NSURL* urlLocal = [[NSURL alloc] initFileURLWithPath:self.destPath];
            if (self.palyBlock) {
                self.palyBlock(self.requestDesc.cellM,urlLocal.absoluteString,self.requestDesc.danmuku);
            }
        }

        return;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
