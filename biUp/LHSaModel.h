//
//  LHSaModel.h
//  biUp
//
//  Created by snowimba on 15/12/7.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHSaModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *icon;

+(instancetype)saCellWithDict:(NSDictionary *)dict;
@end
