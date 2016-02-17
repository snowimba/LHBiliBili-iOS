//
//  LHSpModel.h
//  biUp
//
//  Created by snowimba on 15/12/24.
//  Copyright © 2015年 snowimba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHSpModel : NSObject
@property (nonatomic,copy) NSString *evaluate;
@property (nonatomic,strong) NSArray *episodes;
@property (nonatomic,strong) NSArray *tags;
@property (nonatomic,strong) NSArray *seasons;
+(instancetype)spMWithDict:(NSDictionary *)dict;

@end
