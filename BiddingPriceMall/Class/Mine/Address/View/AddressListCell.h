//
//  AddressListCell.h
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressListCell : UITableViewCell

- (void)setData:(AddressModel *)model;

- (void)setAddressBlock:(XXNSArrayBlock)block;

- (void)editBlock:(XXObjBlock)block;

- (void)deteleBlock:(XXObjBlock)block;

@end

NS_ASSUME_NONNULL_END
