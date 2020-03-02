//
//  PlaceBuyView.h
//  BiddingPriceMall
//
//  Created by zheng on 2019/11/7.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlaceBuyView : UIView

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data block:(XXNSArrayBlock)block closeBlock:(XXVoidBlock)closeBlock;

- (void)reloadBuyView:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
