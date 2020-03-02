

//
//  MyOrderCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/29.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MyOrderCell.h"

@interface MyOrderCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *openPrice;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;

@end

@implementation MyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _mainView.clipsToBounds = YES;
    _mainView.layer.cornerRadius = 8;
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 8;
    _bgView.layer.shadowOffset = CGSizeMake(0.0, 5.0);
    _bgView.layer.shadowColor = kLightGray.CGColor;
    _bgView.layer.shadowOpacity = 0.8; // 必传 默认是0.0
}

- (void)setData:(OrderModel *)model
{
    [self.img sd_setImageWithURL:kUrl(model.titleFile) placeholderImage:kImage(@"")];
    self.productName.text = model.productName;
    self.remark.text = model.remark;
    self.price.text = kStrMerge(@"单价：¥", kStrNum(model.unitPrice));
    self.openPrice.text = kStrNum(model.totalPrice);
    self.number.text = kStrMerge(@"x", kStrNum(model.number));
    self.orderStatus.text = model.orderStatus == 3 ?@"待发货" : model.orderStatus == 4 ?@"待收货" : model.orderStatus == 5 ?@"已完成" :@"全部";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
