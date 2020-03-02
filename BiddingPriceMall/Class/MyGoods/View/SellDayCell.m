//
//  SellDayCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "SellDayCell.h"

@interface SellDayCell ()

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *finishTime;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;

@end

@implementation SellDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(id)model
{
    if ([model isKindOfClass:[Data1 class]]) {
        Data1 *modell = model;
        self.productName.text = modell.productName;
        self.finishTime.text = kIsEmptyStr(modell.createTimeStr) ? @"":modell.createTimeStr;
        self.number.text = kStrNum(modell.number);
        self.orderStatus.text = modell.orderStatus == 0 ? @"挂单" : modell.orderStatus == 1 ? @"买入成功" : modell.orderStatus == 2 ? @"卖出成功" : @"待配送";
    }
    else if ([model isKindOfClass:[Data2 class]]) {
        Data2 *modell = model;
        self.productName.text = modell.productName;
        self.finishTime.text = kIsEmptyStr(modell.createTimeStr) ? @"":modell.createTimeStr;
        self.number.text = kStrNum(modell.number);
        self.orderStatus.text = modell.orderStatus == 0 ? @"挂单" : modell.orderStatus == 1 ? @"买入成功" : modell.orderStatus == 2 ? @"卖出成功" : @"待配送";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
