//
//  XML2Dic.m
//  Day09_1_XmlParse
//
//  Created by apple-jd44 on 15/11/12.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "XML2Dic.h"
#import "DanMuModel.h"

@interface XML2Dic ()
@property (nonatomic, strong) NSString* currentAttribute;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*,NSMutableArray<DanMuModel*>*>* dic;
@end

@implementation XML2Dic
+ (NSDictionary*)dicWithData:(NSString*)data{
    XML2Dic* sd = [[XML2Dic alloc] init];
    [sd parseWithData:data];
    return sd.dic;
}

- (void)parseWithData:(NSString*)str{
//    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:@"<d.*>" options:NSRegularExpressionCaseInsensitive error:nil];
    //正则表达式匹配的范围
    NSArray<NSTextCheckingResult*>* resultArr = [regu matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    //所有弹幕标签
    for (NSTextCheckingResult* re in resultArr) {
        NSString* subStr = [str substringWithRange:re.range];
        DanMuModel* model = [DanMuModel modelWithParameter:[self getParameterWithString:subStr] text:[self getTextWithString:subStr]];
        if (self.dic[model.sendTime] == nil) {
            self.dic[model.sendTime] = [NSMutableArray array];
        }
        [self.dic[model.sendTime] addObject: model];
    }
}

//获取参数
- (NSString*)getParameterWithString:(NSString*)str{
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:@"\".*\"" options:NSRegularExpressionCaseInsensitive error:nil];
    //正则表达式匹配的范围
    NSArray<NSTextCheckingResult*>* resultArr = [regu matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    if (resultArr.count > 0) {
        return [str substringWithRange:NSMakeRange(resultArr.firstObject.range.location + 1, resultArr.firstObject.range.length - 2)];
    }
    return nil;
}

// 获取内容
- (NSString*)getTextWithString:(NSString*)str{
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:@">.*<" options:NSRegularExpressionCaseInsensitive error:nil];
    //正则表达式匹配的范围
    NSArray<NSTextCheckingResult*>* resultArr = [regu matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    if (resultArr.count > 0) {
        return [str substringWithRange:NSMakeRange(resultArr.firstObject.range.location + 1, resultArr.firstObject.range.length - 2)];
    }
    return nil;
}


- (NSMutableDictionary<NSNumber *,NSMutableArray<DanMuModel*> *> *)dic{
    if (_dic == nil) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}
@end
