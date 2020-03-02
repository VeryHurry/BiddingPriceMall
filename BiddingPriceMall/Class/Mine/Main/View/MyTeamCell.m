


//
//  MyTeamCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MyTeamCell.h"

@interface MyTeamCell ()

@property (weak, nonatomic) IBOutlet UILabel *usreName;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *userCount;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *isLively;
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation MyTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(TeamModel *)model
{
    [self.img sd_setImageWithURL:kUrl(model.headImg) placeholderImage:kImage(@"person-center_icon")];
    self.usreName.text = model.userName;
    self.mobile.text = [NSString stringWithFormat:@"（%@）",model.mobile];
    self.userCount.text = kStrNum(model.userCount);
    self.createTime.text = kStrMerge(@"激活时间：", model.createTime);
    self.isLively.text = model.isLively == 1 ? @"已交易" : @"未交易";
    self.isLively.textColor = model.isLively == 1 ? ColorWithHex(0x999999) : kRed;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
