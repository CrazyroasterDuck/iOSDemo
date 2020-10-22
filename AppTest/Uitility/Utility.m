//
//  Utility.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/21.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "Utility.h"

@implementation Utility
+ (NSString *) EncodeString:(NSString *) uncodeString {
    if (uncodeString.length == 0) {
        return nil;
    }
    // 先尝试使用原始字符串创建url
    NSURL *url = [NSURL URLWithString:uncodeString];
    if (url == nil) {// 如果url为nil，说明uncodeString中含有特殊字符串，则调用下面的方法进行转码
        NSString *decodeString = (NSString *)CFBridgingRelease((__bridge CFTypeRef _Nullable)([uncodeString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]));
        url = [NSURL URLWithString:decodeString.length >0 ? decodeString : uncodeString];
    }
    return url.absoluteString;
}
@end
