//
//  NoticeListCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NoticeListCell.h"

@interface NoticeListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *file;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;


@end

@implementation NoticeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NoticeModel *)model
{
    [self.file sd_setImageWithURL:kUrl(model.file) placeholderImage:kImage(@"")];
    self.content.text = model.title;
    self.time.text = model.createTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
