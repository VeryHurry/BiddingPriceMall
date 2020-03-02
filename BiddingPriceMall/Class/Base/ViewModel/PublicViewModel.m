//
//  PublicViewModel.m
//  Futures
//
//  Created by 郑少钦 on 2018/7/5.
//  Copyright © 2018年 zheng. All rights reserved.
//

#import "PublicViewModel.h"

@implementation PublicViewModel

- (void)getinfoBySuc:(SuccessBlock)sucBlock fai:(FailureBlock)faiBlock
{
    NSString *url = [NSString stringWithFormat:@"/info"];
    NSDictionary *dic = @{@"code":@"weiyun"};
    
    [self getWithUrl:url andData:dic andSuccessBlock:^(id success) {
        

            sucBlock(success);
        
    } andFailureBlock:^(id failure) {
        
        faiBlock(@0);
    }];
}

@end
