//
//  LHRequestDesc.h
//  biUp
//
//  Created by snowimba on 16/1/10.
//  Copyright © 2016年 snowimba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHCoderObject.h"
//@class LHDescModel;
@interface LHRequestDesc : YHCoderObject
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *URL;
@property (nonatomic,copy) NSString *titel;
@property (nonatomic,strong) NSNumber *tag_Btn;
@property (nonatomic,strong) id cellM;
@property (nonatomic,copy) NSString *danmuku;
@property (nonatomic,copy) NSString *destPath;
@property (nonatomic,copy) NSString *tempPath;
@property (nonatomic,strong) NSNumber *progressNum;
@end
