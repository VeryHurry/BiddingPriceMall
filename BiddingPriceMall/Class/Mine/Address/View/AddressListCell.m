
//
//  AddressListCell.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AddressListCell.h"

@interface AddressListCell ()

@property (strong, nonatomic) XXNSArrayBlock block ;
@property (strong, nonatomic) XXObjBlock editBlock ;
@property (strong, nonatomic) XXObjBlock deteleBlock ;
@property (strong, nonatomic) AddressModel *model ;
@property (weak, nonatomic) IBOutlet UILabel *usreName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deteleBtn;


@end

@implementation AddressListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.setBtn.xx_touchAreaInsets = UIEdgeInsetsMake(15, 20, 15, 30);
    self.editBtn.xx_touchAreaInsets = UIEdgeInsetsMake(15, 30, 15, 30);
    self.deteleBtn.xx_touchAreaInsets = UIEdgeInsetsMake(15, 30, 15, 30);
}


- (void)setData:(AddressModel *)model
{
    self.model = model;
    self.usreName.text = model.usreName;
    self.mobile.text = model.mobile;
    self.address.text = kStrMerge(model.area, model.address);
    self.setBtn.xx_img = model.defaultAddress == 1 ? kImage(@"address_choice_2") : kImage(@"address_choice_1") ;
    self.setBtn.selected = model.defaultAddress == 1 ? YES : NO ;
//    self.setBtn.selected =model.defaultAddress;
}

- (void)setAddressBlock:(XXNSArrayBlock)block
{
    if (block)
    {
        self.block = [block copy];
    }
}

- (void)editBlock:(XXObjBlock)block
{
    if (block)
    {
        self.editBlock = [block copy];
    }
}

- (void)deteleBlock:(XXObjBlock)block
{
    if (block)
    {
        self.deteleBlock = [block copy];
    }
}

- (IBAction)ser_action:(id)sender
{
//    self.setBtn.selected = !self.setBtn.selected;
//    self.setBtn.xx_img = self.setBtn.selected == 1 ? kImage(@"address_choice_2") : kImage(@"address_choice_1") ;
    self.block(@[self.model,kStrNum(self.setBtn.selected)]);
}

- (IBAction)edit_action:(id)sender
{
    self.editBlock(self.model);
}

- (IBAction)detele_action:(id)sender
{
    self.deteleBlock(self.model);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
