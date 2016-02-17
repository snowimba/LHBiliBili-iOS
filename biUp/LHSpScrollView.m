//
//  LHSpScrollView.m
//  biUp
//
//  Created by snowimba on 15/12/24.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHParam.h"
#import "LHShop.h"
#import "LHSpModel.h"
#import "LHSpScrollView.h"
#import "UIKit+AFNetworking.h"
//#import "LHComTable.h"
#import "LHBusTableView.h"
#import "LHComSpTable.h"
#import "LHDescScroller.h"
@interface LHSpScrollView ()
@property (nonatomic, strong) NSArray* arrDict;
//@property (nonatomic,strong) LHSpModel *cellSM;
@end
@implementation LHSpScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)webDataRequest:(NSString*)param
{

    NSString* fan = [NSString stringWithFormat:@"http://bangumi.bilibili.com/jsonp/seasoninfo/%@.ver?callback=episodeJsonCallback&_=1446863930820", param];
    //    2579
    NSURL* URL = [NSURL URLWithString:fan];

    NSURLRequest* req = [NSURLRequest requestWithURL:URL];

    UIWebView* web = [[UIWebView alloc] init];
    NSProgress* progress = nil;
    [web loadRequest:req progress:&progress
        success:^NSString* _Nonnull(NSHTTPURLResponse* _Nonnull response, NSString* _Nonnull HTML) {

            if (HTML != nil) {

                NSMutableString* str = [NSMutableString stringWithString:HTML];

                [str deleteCharactersInRange:NSMakeRange(0, 20)];

                [str deleteCharactersInRange:NSMakeRange(str.length - 2, 2)];

                NSData* d = [str dataUsingEncoding:NSUTF8StringEncoding];

                NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];

                NSDictionary* dictM = [dict valueForKey:@"result"];
                //                 NSLog(@"%@",dictM);
                LHSpModel* cellM = [LHSpModel spMWithDict:dictM];
                //                 cellM = self.cellSM;
                NSMutableArray* arrM = [NSMutableArray arrayWithCapacity:cellM.episodes.count];
                for (NSDictionary* dict in cellM.episodes) {
                    LHParam* param = [LHParam paramWithDict:dict];
                    [arrM addObject:param];
                }

                self.arrDict = arrM;
                [self showTabelView:cellM];
            }
            return HTML;
        }
        failure:^(NSError* _Nonnull error){
        }];
}

- (void)setCellM:(LHShop*)cellM
{

    _cellM = cellM;

    self.showsHorizontalScrollIndicator = NO;

    self.showsVerticalScrollIndicator = NO;

    self.backgroundColor = [UIColor clearColor];

    self.bounces = NO;

    self.contentSize = CGSizeMake(3 * [UIScreen mainScreen].bounds.size.width, 0);

    //    self.contentOffset = CGPointMake(vW, 0);

    self.pagingEnabled = YES;

    [self webDataRequest:[NSString stringWithFormat:@"%zd", cellM.season_id]];
}

- (void)showTabelView:(LHSpModel*)cellM
{

    CGFloat vW = [UIScreen mainScreen].bounds.size.width;

    for (NSInteger i = 0; i < 3; i++) {
        //            UIView *view = [[UIView alloc] init];

        if (i == 2) {
            LHComSpTable* view = [[LHComSpTable alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
            //            view.separatorStyle = 0;
            view.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:239 / 255.0 alpha:1];
            //            view.cellM = cellM;

            //            view.backgroundColor = [UIColor clearColor];

            view.cellM = [self.arrDict lastObject];

            view.arrSp = [NSArray arrayWithObjects:@"233", nil];
            [self addSubview:view];

            //            self.spTbale = view;
            //            LHComTable* view = [[LHComTable alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
            //            //            view.separatorStyle = 0;
            ////                        view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
            //
            //            view.cellM = [self.arrDict lastObject];
            //
            //            view.backgroundColor = [UIColor clearColor];
            //            [self addSubview:view];
        }
        else if (i == 0) {

            LHBusTableView* view = [[LHBusTableView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
            //            view.separatorStyle = 0;
            view.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:239 / 255.0 alpha:1];
            //            view.cellM = cellM;

            view.cellM = [self.arrDict lastObject];

            //            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
        }
        else {

            LHDescScroller* view = [[LHDescScroller alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
            //            view.separatorStyle = 0;
            view.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:239 / 255.0 alpha:1];
            //            view.cellM = cellM;
            view.arrDict = self.arrDict;
            view.cellM = cellM;
            //            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
        }
    }
}

@end
