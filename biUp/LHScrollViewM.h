//
//  LHScrollViewM.h
//  biUp
//
//  Created by snowimba on 15/12/12.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHScrollViewM : UIView
@property (nonatomic,strong) NSArray *arrDict;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

+(instancetype)scrollViewM;
@end
