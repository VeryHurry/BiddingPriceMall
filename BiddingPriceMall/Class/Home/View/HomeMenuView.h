//
//  HomeMenuView.h
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeMenuView : UIView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr imageArr:(NSArray *)imageArr block:(XXIntegerBlock)block;

@end

NS_ASSUME_NONNULL_END
