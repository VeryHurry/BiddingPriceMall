//
//  MyOrderCell.h
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderCell : UITableViewCell

- (void)setData:(OrderModel *)model;

@end

NS_ASSUME_NONNULL_END
