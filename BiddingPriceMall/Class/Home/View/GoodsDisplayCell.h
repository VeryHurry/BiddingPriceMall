//
//  GoodsDisplayCell.h
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsDisplayCell : UITableViewCell

- (void)setData:(Result2 *)model type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
