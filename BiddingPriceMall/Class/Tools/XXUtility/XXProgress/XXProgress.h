//
//  XXProgress.h
//  TGWebViewController
//
//  Created by Aranion on 2017/10/10.
//  Copyright © 2017年 QR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XXProgress : NSObject
/**
 展示

 @param y y轴位置
 */
+ (void)showWihtY:(CGFloat)y;
/**
 加载完成
 */
+ (void)doneProgress;
/**
 隐藏
 */
+ (void)hiddenProgress;

@end
