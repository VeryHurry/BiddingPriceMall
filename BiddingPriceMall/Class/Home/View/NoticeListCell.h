//
//  NoticeListCell.h
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoticeListCell : UITableViewCell

- (void)setData:(NoticeModel *)model;

@end

NS_ASSUME_NONNULL_END
