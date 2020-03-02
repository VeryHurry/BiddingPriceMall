//
//  ChooseBankCell.h
//  BiddingPriceMall
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseBankCell : UITableViewCell

- (void)setData:(BankModel *)model btnType:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
