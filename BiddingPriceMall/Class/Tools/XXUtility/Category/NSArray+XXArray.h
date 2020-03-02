//
//  NSArray+XXArray.h
//  BaseTest
//
//  Created by GMS_XiaoXin on 17/1/11.
//  Copyright © 2017年 GMS_001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^NSArrayBlock)(id obj);

@interface NSArray (XXArray)

/**
 倒序数组

 @return 颠倒顺序后的数组
 */
- (NSArray *)xx_reversedArr;
/**
 与某个数组

 @param arr1 要合并的数组

 @return 合并后的数组
 */
- (NSMutableArray *)xx_mergingWith:(NSMutableArray *)arr1 ;
/**
 数组转JSON

 @return json
 */
- (NSString *)xx_transformJson;
/**
 JSON转数组

 @param json json

 @return 数组
 */
+ (NSArray *)xx_initWithJson:(NSString *)json;

/**
 初始化数组

 @param count 数据个数
 @return 数组 
 */
+ (NSMutableArray *)xx_initWithObjCount:(NSInteger)count;

@end

#pragma mark- NSMutableArray setter

@interface NSMutableArray(XXArray)

-(void)addObj:(id)i;

-(void)addString:(NSString*)i;

-(void)addBool:(BOOL)i;

-(void)addInt:(int)i;

-(void)addInteger:(NSInteger)i;

-(void)addUnsignedInteger:(NSUInteger)i;

-(void)addCGFloat:(CGFloat)f;

-(void)addChar:(char)c;

-(void)addFloat:(float)i;

-(void)addPoint:(CGPoint)o;

-(void)addSize:(CGSize)o;

-(void)addRect:(CGRect)o;
@end
