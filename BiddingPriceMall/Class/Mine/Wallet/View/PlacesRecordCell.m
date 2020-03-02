//
//  PlacesRecordCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import "PlacesRecordCell.h"

@interface PlacesRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *placesChannel;
@property (weak, nonatomic) IBOutlet UILabel *statically;
@property (weak, nonatomic) IBOutlet UILabel *remark;


@end

@implementation PlacesRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(PlacesModel *)model
{
    self.createTime.text = model.createTime;
    self.placesChannel.text = model.placesChannel == 1 ? @"配送仓单" : model.placesChannel == 2 ? @"仓单买入" : model.placesChannel == 3 ? @"分享配售" : model.placesChannel == 4 ? @"辅导配售" :  @"代理配售" ;
    self.remark.text = kStrMerge(@"备注：", model.remark);
    CGFloat a = model.statically*1.00;
    self.statically.text = model.type == 1 ? [NSString stringWithFormat:@"+%.2f",a] : [NSString stringWithFormat:@"-%.2f",a];
    self.statically.textColor = model.type == 1 ? Home_Text_Color : ColorWithHex(0xFF0000);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
