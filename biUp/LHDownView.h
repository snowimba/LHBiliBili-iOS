//
//  LHDownView.h
//  biUp
//
//  Created by snowimba on 16/1/7.
//  Copyright © 2016年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHDownView : UIView
+ (instancetype)downLoadView;
@property (nonatomic,copy) void(^pushBlock)();
@property (nonatomic,strong) id cellM;
@property (nonatomic,strong) NSArray *arrDict;
@end
