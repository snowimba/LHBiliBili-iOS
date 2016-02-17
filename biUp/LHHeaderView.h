//
//  LHHeaderView.h
//  biUp
//
//  Created by snowimba on 15/12/24.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
+ (instancetype)headerView;
@property (nonatomic,copy) void(^btnClcike)();

@end
