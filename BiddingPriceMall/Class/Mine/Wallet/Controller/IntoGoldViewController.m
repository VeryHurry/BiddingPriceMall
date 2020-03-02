//
//  IntoGoldViewController.m
//  BiddingPriceMall
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 mac. All rights reserved.
//

#import "IntoGoldViewController.h"

@interface IntoGoldViewController ()

@property (weak, nonatomic) IBOutlet UITextField *balance;
@property (weak, nonatomic) IBOutlet UITextField *amount;

@end

@implementation IntoGoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.view.backgroundColor = kBgGray;
    self.nav.title = @"入金";
    NSDictionary *dic = [kUserDefaults objectForKey:def_userModel];
    UserModel *model = [UserModel modelWithJSON:dic];
    self.balance.text = [NSString stringWithFormat:@"%.2f",model.balance];
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
