//
//  PublicViewModel.h
//  Futures
//
//  Created by 郑少钦 on 2018/7/5.
//  Copyright © 2018年 zheng. All rights reserved.
//

#import "XXNetWorkMangerBase.h"

@interface PublicViewModel : XXNetWorkMangerBase

/**
 开关接口
 
 @param sucBlock 成功
 @param faiBlock 失败
 */
- (void)getinfoBySuc:(SuccessBlock)sucBlock fai:(FailureBlock)faiBlock;

@end
