//
//  XXNavView.h
//  YJBestBusiness
//
//  Created by Aranion on 2017/9/4.
//  Copyright © 2017年 YJBest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXNavView : UIView

//0黑色  1白色
@property (assign, nonatomic) NSInteger navType;

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) UIButton *btnRigth ;
@property (strong, nonatomic) UILabel *lblTitel ;
@property (strong, nonatomic) UIButton *btnleft ;

/**
 初始化

 @param type 样式
 @param block 回调
 @return 实例化对象
 */
- (instancetype)initWithType:(NSInteger)type block:(XXIntegerBlock)block;
// 设置透明度
- (void)setNavAlpha:(CGFloat)alpha;

@end
