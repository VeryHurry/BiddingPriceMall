//
//  GoodsDisplayCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/14.
//  Copyright © 2019 mac. All rights reserved.
//

#import "GoodsDisplayCell.h"

@interface GoodsDisplayCell ()

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *openPrice;
@property (weak, nonatomic) IBOutlet UILabel *closePrice;
@property (weak, nonatomic) IBOutlet UILabel *successPrice;

@end

@implementation GoodsDisplayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(Result2 *)model type:(NSInteger)type
{
    
    if (type == 1) {
        _date.font = kFont_Bold(13);
        _openPrice.font = kFont_Bold(13);
        _closePrice.font = kFont_Bold(13);
        _successPrice.font = kFont_Bold(13);
        _date.text = model.dateStr;
        _openPrice.text = model.openPrice;
        _closePrice.text = model.closePrice;
        _successPrice.text = model.scuuessPrice;
    }
    else
    {
        _date.font = kFont_Medium(12);
        _openPrice.font = kFont_Medium(12);
        _closePrice.font = kFont_Medium(12);
        _successPrice.font = kFont_Medium(12);
        _date.text = model.dateStr;
        _openPrice.text = model.openPrice;
        _closePrice.text = model.closePrice;
        _successPrice.text = model.scuuessPrice;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
