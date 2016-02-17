//
//  NSString+Tools.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/5.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)
/** 把字符串格式化成xx万的形式*/
+ (NSString*)stringWithFormatNum:(NSInteger)num;
+ (NSString *)exchangeStr:(NSString *)str;
//根据正则表达式返回对应子字符串
- (NSArray<NSString *>*)subStringsWithRegularExpression:(NSString*)regularExpression;
/*
 根据字典转成sign
 */
+ (NSString*)signStringWithDic:(NSDictionary*)dic;
/*
 根据字符串转成sign
 */
+ (NSString*)signStringWithString:(NSString*)str;

- (NSString *)URLEncodedString:(NSString *)str;

-(NSString *)deleStringLastChar;

@end
