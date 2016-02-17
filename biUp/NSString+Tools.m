//
//  NSString+Tools.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/5.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "NSString+Tools.h"
#import "NSDictionary+Tools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Tools)

+ (NSString *)exchangeStr:(NSString *)str{
    
    for (NSInteger i = 0; i < str.length ; i++) {
        if ([str characterAtIndex:i]<'0'||[str characterAtIndex:i]>'9') {
            return str;
        }
        
    }
    
    return [NSString stringWithFormatNum:[str integerValue]];
    
}



+ (NSString*)stringWithFormatNum:(NSInteger)num{
    
    return [NSString stringWithFormat:@"%@", num >= 10000 ? [NSString stringWithFormat:@"%0.1f万", (num / 10000.0)] : [NSString stringWithFormat:@"%zd",num]];
    
//    if (num >= 10000) {
//        return [NSString stringWithFormat:@"%.1lf万",num * 1.0 / 10000];
//    }
//    return [NSString stringWithFormat:@"%ld", (long)num];
}

- (NSArray<NSString *>*)subStringsWithRegularExpression:(NSString*)regularExpression{
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:regularExpression options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray* objArr = [regu matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    if (objArr.count > 0) {
        NSMutableArray* returnArr = [NSMutableArray array];
        for (NSTextCheckingResult* rs in objArr) {
            [returnArr addObject:[self substringWithRange:rs.range]];
        }
        return [returnArr copy];
    }
    return nil;
}

+ (NSString*)signStringWithDic:(NSDictionary*)dic{
    //将字典键降序排列后转成md5
    return [self signStringWithString: [dic appendGetSortParameterWithBasePath:@""]];
}

+ (NSString*)signStringWithString:(NSString*)str{
    //开始md5转换
    const char *cStr = [[str stringByAppendingString: @"2ad42749773c441109bdc0191257a664"] UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02X",result[i]];
    }
    return [hash lowercaseString];
}

/**
 *  编码
 */
- (NSString *)URLEncodedString:(NSString *)str
{
# pragma clang diagnostic push
# pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)str,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
# pragma clang diagnostic pop
    
    return result;
}

/**
 *  解码
 *
 */
- (NSString*)URLDecodedString:(NSString *)str
{
# pragma clang diagnostic push
# pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)str, CFSTR(""),kCFStringEncodingUTF8));
# pragma clang diagnostic pop
    
    return result;
}

-(NSString *)deleStringLastChar{

    NSMutableString *strM = [NSMutableString stringWithString:self];
    for (NSInteger i = 0; i < self.length ; i++) {
        
        if ([self characterAtIndex:i] == 'G') {
            [strM deleteCharactersInRange:NSMakeRange(i, self.length-i)];
            break;
        }
        
    }
    

    return strM;
}

@end
