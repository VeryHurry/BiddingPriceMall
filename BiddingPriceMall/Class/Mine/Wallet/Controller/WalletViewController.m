//
//  WalletViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import "WalletViewController.h"
#import "PlacesRecordViewController.h"
#import "CapitalSubsidiaryViewController.h"
#import "IntegralListViewController.h"
#import "CanUsePlaceViewController.h"
#import "WalletModel.h"
@interface WalletViewController ()

@property (weak, nonatomic) IBOutlet UILabel *enableBalance;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *placesNum;
@property (weak, nonatomic) IBOutlet UILabel *integral;

@property (nonatomic, strong) WalletModel *model;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.nav.title = @"我的钱包";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getWalletList];
}

#pragma mark - networking
-(void)getWalletList
{
    NSDictionary *dic = @{@"id":[kUserDefaults objectForKey:def_id]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_myWallet andData:dic andSuccessBlock:^(id success) {
        self.model = [WalletModel modelWithJSON:success];
        self.balance.text = [NSString stringWithFormat:@"%.2f",self.model.data.balance];
        self.enableBalance.text = [NSString stringWithFormat:@"%.2f",self.model.data.enableBalance];
        self.placesNum.text = [NSString stringWithFormat:@"%.2f",self.model.data.placesNum];
        self.integral.text = [NSString stringWithFormat:@"%.2f",self.model.data.integral];
    } andFailureBlock:^(id failure) {
        
    }];
}

- (IBAction)capital:(id)sender
{
    [self xx_pushVC:[CapitalSubsidiaryViewController new]];
}

- (IBAction)place:(id)sender
{
    [self xx_pushVC:[PlacesRecordViewController new]];
}

- (IBAction)ingetral:(id)sender
{
    [self xx_pushVC:[IntegralListViewController new]];
}

- (IBAction)look:(id)sender
{
    CanUsePlaceViewController *vc = [CanUsePlaceViewController new];
    vc.flag = 1;
    [self xx_pushVC:vc];
}

- (IBAction)exchange:(id)sender
{
    [MBProgressHUD showMessag:@"努力开发中，敬请期待" toView:kWindow andShowTime:1];
}

- (IBAction)conversion1:(id)sender
{
    
}

- (IBAction)conversion2:(id)sender
{
    
}

@end
