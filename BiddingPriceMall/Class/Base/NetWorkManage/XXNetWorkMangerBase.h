//
//  XXNetWorkMangerBase.h
//  gms
//
//  Created by GMS_001 on 17/1/4.
//  Copyright © 2017年 Gumeishu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XXNetWorkMangerBase : NSObject

/**
 获取token
 无返回token  成功后取 kToken 数据
 */
- (void)getTokenSuccessBlock:(SuccessBlock)sucBlock;

/**
 过滤关键字

 @param arrData 数据数组
 @return 过滤后的数组
 */
- (NSMutableArray *)arrDataFilter:(NSArray *)arrData;

/**
 过滤关键字

 @param arrData 字典
 @return 过滤后的字典
 */
- (NSMutableDictionary *)dataFilter:(NSDictionary *)arrData;
// 获取单利对象
+(instancetype)sharedNetWorkManger;

/**
 GET请求
 
 @param url      链接
 @param dic      参数
 @param sucBlock 成功
 @param falBlock 是吧
 */
- (void)getWithUrl:(NSString *)url andData:(NSDictionary *)dic andSuccessBlock:(SuccessBlock)sucBlock andFailureBlock:(FailureBlock)falBlock;

/**
 POST请求
 
 @param url      链接
 @param dic      参数
 @param sucBlock 成功
 @param falBlock 是吧
 */
- (void)postWithUrl:(NSString *)url andData:(NSDictionary *)dic andSuccessBlock:(SuccessBlock)sucBlock andFailureBlock:(FailureBlock)falBlock;
/**
 PUT请求
 
 @param url      链接
 @param dic      参数
 @param sucBlock 成功
 @param falBlock 是吧
 */
- (void)putWithUrl:(NSString *)url andData:(NSDictionary *)dic andSuccessBlock:(SuccessBlock)sucBlock andFailureBlock:(FailureBlock)falBlock;
/**
 DELETE请求
 
 @param url      链接
 @param dic      参数
 @param sucBlock 成功
 @param falBlock 是吧
 */
- (void)deleteWithUrl:(NSString *)url andData:(NSDictionary *)dic andSuccessBlock:(SuccessBlock)sucBlock andFailureBlock:(FailureBlock)falBlock;

- (void)postWithUrl:(NSString *)url andArrData:(NSArray *)arr andSuccessBlock:(SuccessBlock)sucBlock andFailureBlock:(FailureBlock)falBlock;

- (void)postWithUrl:(NSString *)url imageData:(NSData *)imageData fileName:(NSString *)fileName parameter:(NSDictionary *)parameter andSuccessBlock:(SuccessBlock)sucBlock andFailureBlock:(FailureBlock)falBlock;

@end
