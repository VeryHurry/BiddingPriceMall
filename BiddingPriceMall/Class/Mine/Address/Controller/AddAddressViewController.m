
//
//  AddAddressViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AddAddressViewController.h"
#import "JYAddressPicker.h"
#import "WMZDialog.h"

@interface AddAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usreName;
@property (weak, nonatomic) IBOutlet UITextField *area;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;

@property (nonatomic, strong) NSArray *selectedArr;
@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.nav.title = @"新增地址";
    self.setBtn.xx_touchAreaInsets = UIEdgeInsetsMake(15, 20, 15, 20);
    if (!kIsEmptyObj(_model)) {
        self.usreName.text = _model.usreName;
        self.mobile.text = _model.mobile;
        self.area.text = _model.area;
        self.address.text = _model.address;
        self.setBtn.xx_img = _model.defaultAddress == 1 ? kImage(@"address_choice_2") : kImage(@"address_choice_1") ;
        self.setBtn.selected = _model.defaultAddress;
    }
}

#pragma mark - network
- (void)andAddress
{
    NSString *defaultAddress = self.setBtn.selected ? @"1" : @"0";
    NSDictionary *dic = @{@"accountId":[kUserDefaults objectForKey:def_id],@"usreName":self.usreName.text,@"area":self.area.text,@"address":self.address.text,@"mobile":self.mobile.text,@"defaultAddress":defaultAddress};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_andAddress andData:dic andSuccessBlock:^(id success) {
        [self xx_pop];
        [MBProgressHUD showSuccess:success[@"msg"] toView:kWindow];
        
    } andFailureBlock:^(id failure) {
        
    }];
}

- (void)editAddress
{
    NSString *defaultAddress = self.setBtn.selected ? @"1" : @"0";
    NSDictionary *dic = @{@"id":kStrNum(_model.ID),@"usreName":self.usreName.text,@"area":self.area.text,@"address":self.address.text,@"mobile":self.mobile.text,@"defaultAddress":defaultAddress};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_updateAddress andData:dic andSuccessBlock:^(id success) {
        [self xx_pop];
        [MBProgressHUD showSuccess:success[@"msg"] toView:kWindow];
        
    } andFailureBlock:^(id failure) {
        
    }];
}

- (IBAction)chooseArea:(id)sender
{
    
    Dialog()
    .wEventMenuClickSet(^(id anyID, NSInteger section, NSInteger row) {
        NSLog(@"选中 %@ %ld %ld",anyID,section,row);
    })
    .wEventOKFinishSet(^(id anyID, id otherData) {
        NSLog(@"选中 %@ %@",anyID,otherData);
        NSString *str = kString(otherData);
        str = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
        self.area.text = str;
    })
    //分隔符
    .wSeparatorSet(@",")
    .wChainTypeSet(2)
    .wLocationTypeSet(3)
    .wTypeSet(DialogTypeLocation)
    .wStart();
    
//    if (self.selectedArr) {
//
//        NSArray *defaultValues = @[[self.selectedArr objectAtIndex:0][@"text"],[self.selectedArr objectAtIndex:1][@"text"],[self.selectedArr objectAtIndex:2][@"text"]];
//        JYAddressPicker *addressPicker = [JYAddressPicker jy_showAt:self defaultShow:defaultValues];
//        addressPicker.selectedItemBlock = ^(NSArray *addressArr) {
//
//            NSString *province = [addressArr objectAtIndex:0][@"text"];
//            NSString *city = [addressArr objectAtIndex:1][@"text"];
//            NSString *county = [addressArr objectAtIndex:2][@"text"];
//
//            self.area.text = [NSString stringWithFormat:@"%@%@%@",province,city,county];
//            self.selectedArr = addressArr;
//        };
//    }else{
//        JYAddressPicker *addressPicker = [JYAddressPicker jy_showAt:self];
//        addressPicker.selectedItemBlock = ^(NSArray *addressArr) {
//
//            NSString *province = [addressArr objectAtIndex:0][@"text"];
//            NSString *city = [addressArr objectAtIndex:1][@"text"];
//            NSString *county = [addressArr objectAtIndex:2][@"text"];
//
//            self.area.text = [NSString stringWithFormat:@"%@%@%@",province,city,county];
//            self.selectedArr = addressArr;
//        };
//
//    }
}

- (IBAction)setDefaultAddress:(id)sender
{
        self.setBtn.selected = !self.setBtn.selected;
        self.setBtn.xx_img = self.setBtn.selected == 1 ? kImage(@"address_choice_2") : kImage(@"address_choice_1") ;
}

- (IBAction)save:(id)sender
{
    if (kIsEmptyStr(_usreName.text))
    {
        [MBProgressHUD showError:@"请先输入姓名"];
    }
    else if (kIsEmptyStr(_mobile.text))
    {
        [MBProgressHUD showError:txt_emptyPhone];
    }
    else if (![XXTollClass isTelphoneNum:_mobile.text])
    {
        [MBProgressHUD showError:txt_phoneError];
    }
    else if (kIsEmptyStr(_area.text))
    {
        [MBProgressHUD showError:@"请先选择地区"];
    }
    else if (kIsEmptyStr(_address.text))
    {
        [MBProgressHUD showError:@"请先输入详细地址"];
    }
    else
    {
        if (!kIsEmptyObj(_model)) {
            [self editAddress];
        }
        else
        {
            [self andAddress];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
