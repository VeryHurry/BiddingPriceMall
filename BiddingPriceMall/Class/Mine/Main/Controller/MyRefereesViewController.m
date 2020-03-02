//
//  MyRefereesViewController.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MyRefereesViewController.h"

@interface MyRefereesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *parentName;
@property (weak, nonatomic) IBOutlet UILabel *parentMobile;

@end

@implementation MyRefereesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.nav.title = @"我的推荐人";
    NSDictionary *dic = [kUserDefaults objectForKey:def_userModel];
    UserModel *model = [UserModel modelWithJSON:dic];
    self.parentName.text = kIsEmptyStr(model.parentName)?@"无":model.parentName;
    self.parentMobile.text = kIsEmptyStr(model.parentMobile)?@"无":model.parentMobile;
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
