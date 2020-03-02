//
//  DES3Util.h
//  MTTWallet
//
//  Created by mtt on 2017/3/31.
//  Copyright © 2017年 mtt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject

//加密
+(NSString *)doEncryptStr:(NSString *)originalStr;
//解密
+(NSString*)doDecEncryptStr:(NSString *)encryptStr;


@end
