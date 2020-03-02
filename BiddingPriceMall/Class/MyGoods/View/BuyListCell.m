
//
//  BuyListCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import "BuyListCell.h"

@interface BuyListCell ()

@property (strong, nonatomic) BuyModel *model ;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *unitPrice;
@property (weak, nonatomic) IBOutlet UILabel *number;


@end

@implementation BuyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(BuyModel *)model
{
    self.model = model;
    self.productName.text = model.productName;
    self.unitPrice.text = [NSString stringWithFormat:@"%.2f",model.unitPrice];
    self.number.text = kStrNum(model.number);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
