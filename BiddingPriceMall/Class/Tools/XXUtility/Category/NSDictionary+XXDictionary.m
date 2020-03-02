//
//  NSDictionary+XXDictionary.m
//  BaseTest
//
//  Created by GMS_XiaoXin on 17/1/11.
//  Copyright © 2017年 GMS_001. All rights reserved.
//

#import "NSDictionary+XXDictionary.h"

@implementation NSDictionary (XXDictionary)
// 遍历字典
- (void)xx_obj:(NSDictionaryBlock)block
{
    NSArray *arr = self.allKeys;
    
    for (NSString *key in arr)
    {
        block(key,self[key]);
    }
}
/**
 *  @brief NSDictionary转换成JSON字符串
 *
 *  @return  JSON字符串
 */
-(NSString *)xx_transformJson{
    NSError *error = nil;
    //NSJSONWritingPrettyPrinted:指定生成的JSON数据应使用空格旨在使输出更加可读。如果这个选项是没有设置,最紧凑的可能生成JSON表示。
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil)
    {
        //NSData转换为String
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    else if ([jsonData length] == 0 &&
             error == nil)
    {
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil)
    {
        NSLog(@"An error happened = %@", error);
    }
    return @"111";

    
}
/**
 *  @brief  将NSDictionary转换成XML 字符串
 *
 *  @return XML 字符串
 */
- (NSString *)xx_transformXML {
    
    NSString *xmlStr = @"<xml>";
    
    for (NSString *key in self.allKeys) {
        
        NSString *value = [self objectForKey:key];
        
        xmlStr = [xmlStr stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>", key, value, key]];
    }
    
    xmlStr = [xmlStr stringByAppendingString:@"</xml>"];
    
    return xmlStr;
}

/**
 josn转字典
 
 @param json json
 
 @return 字典
 */
+ (NSDictionary *)xx_initWithJson:(NSString *)json
{
    if (!json)
    {
        return nil;
    }
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
/**
 与某个字典合并
 
 @param dic 要合并的字典
 
 @return 合并后的字典
 */
- (NSDictionary *)xx_mergingWith:(NSDictionary *)dic
{
    if (!dic)
    {
        return nil;
    }
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:self];
    
    [dic xx_obj:^(id key, id obj) {
       
        [mdic setObject:obj forKey:key];
        
    }];
    
    return [NSDictionary dictionaryWithDictionary:mdic];
}
@end
