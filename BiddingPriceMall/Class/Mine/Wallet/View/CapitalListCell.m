//
//  CapitalListCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "CapitalListCell.h"

@interface CapitalListCell ()

@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *channel;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *currentBalance;

@end

@implementation CapitalListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(CapitalModel *)model
{
    self.createTime.text = model.createTime;
    self.channel.text = model.channel == 1 ? @"买入普通订单" : model.channel == 2 ? @"买入配送订单" : model.channel == 3 ? @"卖出普通订单" : model.channel == 4 ? @"卖出配送订单" : model.channel == 5 ? @"直接分享人收益" : model.channel == 6 ? @"买入提货订单" : model.channel == 7 ? @"提现订单" : model.channel == 8 ? @"余额转换可用提现" :  @"可用提现转换余额";
    self.orderNo.text = kStrMerge(@"订单号：", model.orderNo);
    self.remark.text = model.remark;
    self.currentBalance.text = kStrMerge(@"当前可用余额：", model.createTime);
    self.balance.text = model.type == 1 ? kStrMerge(@"+", kStrNum(model.balance)) : kStrMerge(@"-", kStrNum(model.balance));
    self.balance.textColor = model.type == 1 ? Home_Text_Color : ColorWithHex(0xFF0000);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
