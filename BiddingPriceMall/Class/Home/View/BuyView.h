//
//  BuyView.h
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BuyView : UIView
@property (weak, nonatomic) IBOutlet UILabel *entrustPrice;
@property (weak, nonatomic) IBOutlet UILabel *availableAmount;
@property (weak, nonatomic) IBOutlet UIButton *remember;
@property (weak, nonatomic) IBOutlet UIButton *cut;
@property (weak, nonatomic) IBOutlet UIButton *add;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *canBuyNum;
@property (weak, nonatomic) IBOutlet UILabel *entrustNum;
@property (weak, nonatomic) IBOutlet UILabel *payAmount;
@property (weak, nonatomic) IBOutlet UIButton *close;

- (instancetype)initWithFrame:(CGRect)frame data:(NSArray *)data block:(XXNSArrayBlock)block closeBlock:(XXVoidBlock)closeBlock;

@end

NS_ASSUME_NONNULL_END
