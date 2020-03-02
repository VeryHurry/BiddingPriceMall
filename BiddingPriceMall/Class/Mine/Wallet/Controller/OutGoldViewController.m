
//
//  OutGoldViewController.m
//  BiddingPriceMall
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "OutGoldViewController.h"
#import "AddBankViewController.h"
#import "BankListModel.h"
#import "ChooseView.h"

@interface OutGoldViewController ()

@property (nonatomic, strong) BankListModel *model;
@property (nonatomic, strong) ChooseView *chooseView;
@property (nonatomic, strong) UIView *maskView;

@property (weak, nonatomic) IBOutlet UITextField *balance;
@property (weak, nonatomic) IBOutlet UITextField *bankNo;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *code;

@end

@implementation OutGoldViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.chooseView removeFromSuperview];
    self.chooseView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getBankList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.nav.title = @"出金";
    NSDictionary *dic = [kUserDefaults objectForKey:def_userModel];
    UserModel *model = [UserModel modelWithJSON:dic];
    self.balance.text = [NSString stringWithFormat:@"%.2f",model.enableBalance];
    [self.view addSubview:self.maskView];
    
    
}

#pragma mark - networking
-(void)getBankList
{
    NSDictionary *dic = @{@"accountId":[kUserDefaults objectForKey:def_id],@"page":@"1",@"rows":@"100"};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_bankCardList andData:dic andSuccessBlock:^(id success) {
        self.model = [BankListModel modelWithJSON:success];
        [self.view addSubview:self.chooseView];
    } andFailureBlock:^(id failure) {
        
    }];
}


- (IBAction)choose:(id)sender
{
    if (!kIsEmptyObj(self.model)) {
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 0.4;
            self.chooseView.frame = kFrame(0, kScreen_H-self.chooseView.xx_height-kSafeAreaBottomHeight, kScreen_W, self.chooseView.xx_height);
        }];
    }
}

- (IBAction)sure:(id)sender
{
    
}

- (ChooseView *)chooseView
{
    if (!_chooseView) {
        CGFloat height = self.model.total > 4 ? 230 : self.model.total *50;
        _chooseView = [[ChooseView alloc]initWithFrame:kFrame(0, kScreen_H, kScreen_W, height+50+60) data:self.model block:^(NSArray *arr) {
            [self hideChooseView];
        } andBlock:^{
            [self hideChooseView];
            [self xx_pushVC:[self xx_getSb:@"Bank" identifier:@"addBank_vc"]];
        } closeBlock:^{
            [self hideChooseView];
        }];
    }
    return _chooseView;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:kFrame(0, kNav_H, kScreen_W, kScreen_H-kSafeAreaBottomHeight-kNav_H)];
        _maskView.backgroundColor = kBlack;
        _maskView.alpha = 0;
        [_maskView xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [UIView animateWithDuration:0.2 animations:^{
                [self hideChooseView];
            }];
        }];
    }
    return _maskView;
}

- (void)hideChooseView
{
    [self.view endEditing:YES];
    self.maskView.alpha = 0;
    self.chooseView.frame = kFrame(0, kScreen_H, kScreen_W, self.chooseView.xx_height);
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
