//
//  GoodsListCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import "GoodsListCell.h"

@interface GoodsListCell ()

@property (strong, nonatomic) XXObjBlock block ;
@property (strong, nonatomic) Rows *model ;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *remark;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *openPrice;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@end

@implementation GoodsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _mainView.clipsToBounds = YES;
    _mainView.layer.cornerRadius = 10;
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.shadowOffset = CGSizeMake(0.0, 5.0);
    _bgView.layer.shadowColor = kLightGray.CGColor;
    _bgView.layer.shadowOpacity = 0.8;
    
    
}

- (void)setData:(Rows *)model
{
    self.model = model;
    [self.img sd_setImageWithURL:kUrl(model.titleFile) placeholderImage:kImage(@"")];
    self.productName.text = model.productName;
    self.remark.text = model.remark;
    self.price.text = kStrNum(model.newPrice);
    self.openPrice.text = kStrMerge(@"开市价：¥", kStrNum(model.openPrice));
}

- (void)tapBlock:(XXObjBlock)block
{
    if (block)
    {
        self.block = [block copy];
    }
}

- (IBAction)tap:(id)sender
{
    self.block(self.model);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
