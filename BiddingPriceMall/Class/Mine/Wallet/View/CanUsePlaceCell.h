//
//  CanUsePlaceCell.h
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CanUsePlaceCell : UITableViewCell

- (void)setData:(Placeslist *)model;

- (void)tapBlock:(XXVoidBlock)block;

@end

NS_ASSUME_NONNULL_END
