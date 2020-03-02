//
//  MyCanBuyCell.h
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyCanBuyCell : UITableViewCell

@property (nonatomic ,strong) UIView *backgroudView;

- (void)setData:(BuyModel *)model;

- (void)tapBlock:(XXVoidBlock)block;

@end

NS_ASSUME_NONNULL_END
