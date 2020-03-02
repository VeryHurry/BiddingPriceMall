//
//  BuyAndSellCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import "BuyAndSellCell.h"

@interface BuyAndSellCell ()

@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *total;

@end

@implementation BuyAndSellCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}

- (void)setData:(NSArray *)arr type:(NSInteger)type
{
    _type.text = arr[0];
    _price.text = arr[1];
    _total.text = arr[2];
    if (type == 1) {
        _type.font = kFont_Bold(12);
        _price.font = kFont_Bold(12);
        _total.font = kFont_Bold(12);
    }
    else
    {
        _type.font = kFont_Medium(12);
        _price.font = kFont_Medium(12);
        _total.font = kFont_Medium(12);
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
