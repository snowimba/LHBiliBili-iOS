//
//  LHCmTwoView.m
//  biUp
//
//  Created by snowimba on 15/12/7.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import "LHCmTwoView.h"

#import "UIImageView+WebCache.h"

#import "AFNetworking.h"

#import "LHDescModel.h"
@interface LHCmTwoView ()
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView1;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl1;
@property (weak, nonatomic) IBOutlet UILabel *descLbl1;
@property (weak, nonatomic) IBOutlet UIImageView *coverView2;
@property (weak, nonatomic) IBOutlet UIImageView *iconView2;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl2;
@property (weak, nonatomic) IBOutlet UILabel *descLbl2;
@property (nonatomic,strong) NSArray *arrDict;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *talkLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end
@implementation LHCmTwoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{

//    NSURL *URL = [NSURL URLWithString:@"http://app.bilibili.com/bangumi/operation_module?_device=android&_hwid=130a7709aeac1793&_ulv=10000&access_key=b938b895c8a7a0af574a6ae76f5631c8&appkey=c1b107428d337928&build=402003&module=index&platform=android&screen=xxhdpi&test=0&ts=1450884356000"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:@"http://app.bilibili.com/bangumi/operation_module?_device=android&_hwid=130a7709aeac1793&_ulv=10000&access_key=b938b895c8a7a0af574a6ae76f5631c8&appkey=c1b107428d337928&build=402003&module=index&platform=android&screen=xxhdpi&test=0&ts=1450884356000" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSMutableArray *arrD = [responseObject valueForKeyPath:@"result"];
        NSDictionary *dictM = arrD[2];
        [self getDataWith:dictM];
        
        [self setCellData];
        
        for (NSInteger i = 0; i < arrD.count ; i++) {
            [self getDataWith:arrD[i]];
            if (self.arrDict.count==1&&[[self.arrDict firstObject] title].length!=0) {
                [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[[self.arrDict firstObject] cover]]];
                self.talkLbl.text = [[self.arrDict firstObject] title];
                //                [arrD removeObjectAtIndex:i];
                break;
            }
            
        }
        
        for (NSInteger i = 0; i < arrD.count ; i++) {
            [self getDataWith:arrD[i]];
            if (self.arrDict.count==1&&[[self.arrDict firstObject] title].length==0) {
                [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[[self.arrDict firstObject] cover]]];
                break;
            }
            
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
//    [manager GET:URL.absoluteString parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
//        
//        //            NSLog(@"%@",responseObject);
//        
//        NSMutableArray *arrD = [responseObject valueForKeyPath:@"result"];
//        NSDictionary *dictM = arrD[2];
//        [self getDataWith:dictM];
//        
//        [self setCellData];
//        
//        for (NSInteger i = 0; i < arrD.count ; i++) {
//             [self getDataWith:arrD[i]];
//            if (self.arrDict.count==1&&[[self.arrDict firstObject] title].length!=0) {
//                [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[[self.arrDict firstObject] cover]]];
//                self.talkLbl.text = [[self.arrDict firstObject] title];
////                [arrD removeObjectAtIndex:i];
//                break;
//            }
//            
//        }
//        
//        for (NSInteger i = 0; i < arrD.count ; i++) {
//            [self getDataWith:arrD[i]];
//            if (self.arrDict.count==1&&[[self.arrDict firstObject] title].length==0) {
//                   [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[[self.arrDict firstObject] cover]]];
//                break;
//            }
//            
//        }
//        
////        [self getDataWith:arrD[3]];
////        
////        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:[[self.arrDict firstObject] cover]]];
////        self.talkLbl.text = [[self.arrDict firstObject] title];
////        
////        [self getDataWith:arrD[4]];
////        
////        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:[[self.arrDict firstObject] cover]]];
//        
//        
//        
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        
//    }];

}

- (void)setCellData{

    LHDescModel *cellM = [self.arrDict firstObject];
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:cellM.cover]];
    
    [self.iconView1 sd_setImageWithURL:[NSURL URLWithString:cellM.up_face]];
    
    self.titleLbl1.text = cellM.up;
    
    self.descLbl1.text = cellM.title;

    cellM = [self.arrDict lastObject];
    [self.coverView2 sd_setImageWithURL:[NSURL URLWithString:cellM.cover]];
    
    [self.iconView2 sd_setImageWithURL:[NSURL URLWithString:cellM.up_face]];
    
    self.titleLbl2.text = cellM.up;
    
    self.descLbl2.text = cellM.title;


}



- (void)getDataWith:(NSDictionary *)dict{
    
    NSArray *arr = [dict valueForKey:@"body"];
    
    NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:arr.count];
    //            NSLog(@"%@",dictM[@"0"]);
    for (NSInteger i = 0; i < arr.count ; i++) {
        
        
        LHDescModel *post = [LHDescModel cellMWithDict:arr[i]];
        [mutablePosts addObject:post];
        
    }
    
    self.arrDict = mutablePosts;
    
}


+(instancetype)towViewWith{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"LHCmTwoView" owner:nil options:nil]lastObject];
}

@end
