//
//  LHSearchView.h
//  biUp
//
//  Created by snowimba on 15/12/29.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHSearchView : UIView
@property (nonatomic,copy) void(^searchBlock)(NSString*);
@property (weak, nonatomic) IBOutlet UITextField* textFieldV;
+ (instancetype)searchView;
@end
