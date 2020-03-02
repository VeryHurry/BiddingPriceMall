//
//  PayPasswordView.h
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/16.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayPasswordView : UIView

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data block:(XXNSArrayBlock)block closeBlock:(XXVoidBlock)closeBlock;

@end

NS_ASSUME_NONNULL_END
