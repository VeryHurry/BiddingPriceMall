//
//  BankListCell.h
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BankListCell : UITableViewCell

- (void)setData:(BankModel *)model;
- (void)deteleBlock:(XXObjBlock)block;
@end

NS_ASSUME_NONNULL_END
