//
//  AddBankViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/23.
//  Copyright © 2019 mac. All rights reserved.
//

#import "AddBankViewController.h"
#import "WMZDialog.h"

@interface AddBankViewController ()

@property (weak, nonatomic) IBOutlet UITextField *bankAccount;
@property (weak, nonatomic) IBOutlet UITextField *usreName;
@property (weak, nonatomic) IBOutlet UITextField *bankName;
@property (weak, nonatomic) IBOutlet UITextField *area;
@property (weak, nonatomic) IBOutlet UITextField *bankAddress;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (nonatomic, strong) NSArray *bankArr;
@end

@implementation AddBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.nav.title = @"添加银行卡";
    self.setBtn.xx_touchAreaInsets = UIEdgeInsetsMake(15, 20, 15, 20);
    [self getBankList];
}

#pragma mark - network
- (void)andBank
{
    NSString *defaultBank = self.setBtn.selected ? @"1" : @"0";
    NSDictionary *dic = @{@"accountId":[kUserDefaults objectForKey:def_id],@"usreName":self.usreName.text,@"area":self.area.text,@"bankAddress":self.bankAddress.text,@"bankName":self.bankName.text,@"bankAccount":self.bankAccount.text,@"defaultAddress":defaultBank};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_andBank andData:dic andSuccessBlock:^(id success) {
        [self xx_pop];
        [MBProgressHUD showSuccess:success[@"msg"] toView:kWindow];
        
    } andFailureBlock:^(id failure) {
        
    }];
}

- (void)getBankList
{
    NSDictionary *dic = @{};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_bankList andData:dic andSuccessBlock:^(id success) {

        self.bankArr = success[@"rows"];
        
    } andFailureBlock:^(id failure) {
        
    }];
}

- (IBAction)chooseBank:(id)sender
{
    if (!kIsEmptyArr(self.bankArr)) {
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < self.bankArr.count; i++) {
            [temp addObject:self.bankArr[i][@"bankName"]];
        }
        Dialog().wTypeSet(7)
        .wEventFinishSet(^(id anyID, NSIndexPath *path, DialogType type) {
            NSLog(@"%@ %@",anyID,path);
            self.bankName.text = kString(anyID);
        })
        .wTitleSet(@"选择所属银行").wTitleColorSet([UIColor redColor]).wTitleFontSet(16.0)
        .wDataSet([NSArray arrayWithArray:temp])
        .wStart();
    }
    
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
}

- (IBAction)setDefaultAddress:(id)sender
{
    self.setBtn.selected = !self.setBtn.selected;
    self.setBtn.xx_img = self.setBtn.selected == 1 ? kImage(@"address_choice_2") : kImage(@"address_choice_1") ;
}

- (IBAction)save:(id)sender
{
    if (kIsEmptyStr(_bankAccount.text))
    {
        [MBProgressHUD showError:@"请先输入卡号"];
    }
    else if (kIsEmptyStr(_usreName.text))
    {
        [MBProgressHUD showError:@"请先输入持卡人姓名"];
    }
    else if (kIsEmptyStr(_bankName.text))
    {
        [MBProgressHUD showError:@"请先选择所属银行"];
    }
    else if (kIsEmptyStr(_area.text))
    {
        [MBProgressHUD showError:@"请先选择所属地区"];
    }
    else if (kIsEmptyStr(_bankAddress.text))
    {
        [MBProgressHUD showError:@"请先输入开户行详情"];
    }
    else
    {
        [self andBank];
    }
}


@end
