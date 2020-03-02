
//
//  IntegralListCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "IntegralListCell.h"

@interface IntegralListCell ()


@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *channel;
@property (weak, nonatomic) IBOutlet UILabel *integral;
@property (weak, nonatomic) IBOutlet UILabel *remark;

@end

@implementation IntegralListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(IntegralModel *)model
{
    self.createTime.text = model.createTime;
    self.channel.text = model.channel == 1 ? @"赠送" : @"兑换" ;
    self.remark.text = kStrMerge(@"备注：", model.remark);
    self.integral.text = model.type == 1 ? [NSString stringWithFormat:@"+%.2f",model.integral] : [NSString stringWithFormat:@"-%.2f",model.integral];
    self.integral.textColor = model.type == 1 ? Home_Text_Color : ColorWithHex(0xFF0000);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
