//
//  WithdrawConverBalanceVC.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/30.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WithdrawConverBalanceVC.h"

@interface WithdrawConverBalanceVC ()

@property (weak, nonatomic) IBOutlet UITextField *balance;
@property (weak, nonatomic) IBOutlet UITextField *withdraw;
@property (weak, nonatomic) IBOutlet UITextField *conver;
@property (nonatomic, strong) UserModel *model;

@end

@implementation WithdrawConverBalanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.nav.title = @"资金转入";
    NSDictionary *dic = [kUserDefaults objectForKey:def_userModel];
    self.model = [UserModel modelWithJSON:dic];
    self.withdraw.text = [NSString stringWithFormat:@"%.2f",self.model.enableBalance];
    self.balance.text = [NSString stringWithFormat:@"%.2f",self.model.balance];;
}

- (IBAction)sure:(id)sender
{
    if (kIsEmptyStr(_conver.text)) {
        [MBProgressHUD showError:@"请先输入转换金额" toView:kWindow];
    }
    else
    {
        [self converBalance];
    }
}

#pragma mark - networking
-(void)converBalance
{
    NSDictionary *dic = @{@"id":[kUserDefaults objectForKey:def_id],@"balance":_conver.text};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_withdrawConverBalance andData:dic andSuccessBlock:^(id success) {
        [MBProgressHUD showMessag:success[@"msg"] toView:kWindow andShowTime:1];
        [self xx_pop];
    } andFailureBlock:^(id failure) {
        [MBProgressHUD hideHUDForView:kWindow];
    }];
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
