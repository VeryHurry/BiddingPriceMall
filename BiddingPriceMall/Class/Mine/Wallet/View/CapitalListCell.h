//
//  CapitalListCell.h
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CapitalListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CapitalListCell : UITableViewCell

- (void)setData:(CapitalModel *)model;

@end

NS_ASSUME_NONNULL_END
