//
//  ChooseView.h
//  BiddingPriceMall
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseView : UIView

- (instancetype)initWithFrame:(CGRect)frame data:(BankListModel *)model block:(XXNSArrayBlock)block andBlock:(XXVoidBlock)andBlock closeBlock:(XXVoidBlock)closeBlock;

@end

NS_ASSUME_NONNULL_END
