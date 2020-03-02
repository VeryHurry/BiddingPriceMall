//
//  GoodsListCell.h
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsListCell : UITableViewCell

- (void)setData:(Rows *)model;

- (void)tapBlock:(XXObjBlock)block;

@end

NS_ASSUME_NONNULL_END
