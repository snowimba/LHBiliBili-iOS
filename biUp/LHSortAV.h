//
//  LHSortAV.h
//  biUp
//
//  Created by snowimba on 16/1/11.
//  Copyright © 2016年 snowimba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHSortAV : NSObject
@property (nonatomic,strong) NSNumber *AV;
@property (nonatomic,strong) NSNumber *P;
@property (nonatomic,strong) NSNumber *CID;
@property (nonatomic,copy) NSString *Title;
@property (nonatomic,copy) NSString *Mp4Url;
+ (instancetype)sortAVWithDict:(NSDictionary *)dict;
@end
