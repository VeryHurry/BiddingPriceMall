//
//  LoginVC.m
//  BiddingPriceMall
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "UserModel.h"

@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *user_txt;
@property (weak, nonatomic) IBOutlet UITextField *password_txt;
@property (weak, nonatomic) IBOutlet UIButton *password_btn;

@property (weak, nonatomic) IBOutlet UIButton *remember_btn;
@property (weak, nonatomic) IBOutlet UIButton *forget_btn;
@property (weak, nonatomic) IBOutlet UIButton *register_btn;

@end

@implementation LoginVC
-(void)viewDidLoad
{
    self.remember_btn.xx_touchAreaInsets = UIEdgeInsetsMake(10, 20, 10, 20);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!kIsEmptyObj([kUserDefaults objectForKey:def_phone])) {
        _user_txt.text = [kUserDefaults objectForKey:def_phone];
    }
    if (!kIsEmptyObj([kUserDefaults objectForKey:def_password])) {
        _password_txt.text = [kUserDefaults objectForKey:def_password];
        _remember_btn.selected = YES;
        _remember_btn.xx_img = kImage(@"login_remember_1");
    }
}


#pragma mark - networking
//登录
- (void)userLogin
{
    NSDictionary *dic = @{@"accountNo":_user_txt.text,@"password":[DES3Util doEncryptStr:_password_txt.text]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_login andData:dic andSuccessBlock:^(id success) {
        UserModel *model = [UserModel modelWithJSON:success[@"rows"]];
        [kUserDefaults setObject:success[@"rows"] forKey:def_userModel];
        [kUserDefaults setObject:model.accountNo forKey:def_phone];
        [kUserDefaults setObject:model.ID forKey:def_id];
        if (self.remember_btn.selected) {
            [kUserDefaults setObject:self.password_txt.text forKey:def_password];
        }
        else
        {
            [kUserDefaults removeObjectForKey:def_password];
        }
        [kUserDefaults synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [MBProgressHUD showSuccess:txt_login toView:kWindow];
    } andFailureBlock:^(id failure) {
        
    }];
}


- (IBAction)login_action:(id)sender
{
    if (kIsEmptyStr(_user_txt.text))
    {
        [MBProgressHUD showError:txt_emptyPhone];
    }
    else if (![XXTollClass isTelphoneNum:_user_txt.text])
    {
        [MBProgressHUD showError:txt_phoneError];
    }
    else if (kIsEmptyStr(_password_txt.text))
    {
        [MBProgressHUD showError:txt_emptyPassword1];
    }
    else
    {
        [self userLogin];
    }
}

- (IBAction)forget_action:(id)sender
{
   
}

- (IBAction)regiseter_action:(id)sender
{
    
}

- (IBAction)remember_action:(id)sender
{
    _remember_btn.selected = !_remember_btn.selected;
    _remember_btn.xx_img = _remember_btn.selected?kImage(@"login_remember_1"):kImage(@"login_remember_2");
}

- (IBAction)password_action:(id)sender
{
    _password_txt.secureTextEntry = _password_btn.selected;
    _password_btn.selected = !_password_btn.selected;
    _password_btn.xx_img = _password_btn.selected?kImage(@"logon_open"):kImage(@"login_close");
}

@end
