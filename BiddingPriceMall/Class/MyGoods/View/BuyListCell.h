//
//  BuyListCell.h
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BuyListCell : UITableViewCell

- (void)setData:(BuyModel *)model;

@end

NS_ASSUME_NONNULL_END
