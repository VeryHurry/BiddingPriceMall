//
//  NSDictionary+XXDictionary.h
//  BaseTest
//
//  Created by GMS_XiaoXin on 17/1/11.
//  Copyright © 2017年 GMS_001. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^NSDictionaryBlock)(id key,id obj);

@interface NSDictionary (XXDictionary)
/**
 遍历字典

 @param block 代码块
 */
- (void)xx_obj:(NSDictionaryBlock)block;

/**
 与某个字典合并

 @param dic 要合并的字典

 @return 合并后的字典
 */
- (NSDictionary *)xx_mergingWith:(NSDictionary *)dic;
/**
 *  @brief NSDictionary转换成JSON字符串
 *
 *  @return  JSON字符串
 */
-(NSString *)xx_transformJson;
/**
 *  @brief  将NSDictionary转换成XML 字符串
 *
 *  @return XML 字符串
 */
- (NSString *)xx_transformXML;
/**
 josn转字典

 @param json json

 @return 字典
 */
+ (NSDictionary *)xx_initWithJson:(NSString *)json;
@end
