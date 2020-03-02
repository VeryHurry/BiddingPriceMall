//
//  NewPasswordVC.m
//  BiddingPriceMall
//
//  Created by MacStudent on 2019/10/10.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NewPasswordVC.h"

@interface NewPasswordVC ()

@property (weak, nonatomic) IBOutlet UITextField *psd1_txt;
@property (weak, nonatomic) IBOutlet UITextField *psd2_txt;
@property (weak, nonatomic) IBOutlet UIButton *psd1_btn;
@property (weak, nonatomic) IBOutlet UIButton *psd2_btn;

@end

@implementation NewPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav.title = @"忘记密码";
    // Do any additional setup after loading the view.
}

-(void)changePassword
{
    NSDictionary *dic = @{@"accountNo":[kUserDefaults objectForKey:def_phone],@"password1":[DES3Util doEncryptStr:_psd1_txt.text],@"password2":[DES3Util doEncryptStr:_psd2_txt.text]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_forgetPws2 andData:dic andSuccessBlock:^(id success) {
        [kUserDefaults removeObjectForKey:def_password];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [MBProgressHUD showSuccess:success[@"msg"] toView:kWindow];
    } andFailureBlock:^(id failure) {
        
    }];
}

- (IBAction)psd1_action:(id)sender
{
    _psd1_txt.secureTextEntry = _psd1_btn.selected;
    _psd1_btn.selected = !_psd1_btn.selected;
    _psd1_btn.xx_img = _psd1_btn.selected?kImage(@"logon_open"):kImage(@"login_close");
}

- (IBAction)psd2_action:(id)sender
{
    _psd2_txt.secureTextEntry = _psd2_btn.selected;
    _psd2_btn.selected = !_psd2_btn.selected;
    _psd2_btn.xx_img = _psd2_btn.selected?kImage(@"logon_open"):kImage(@"login_close");
}

- (IBAction)sure_action:(id)sender
{
    if (kIsEmptyStr(_psd1_txt.text))
    {
        [MBProgressHUD showError:txt_emptyPassword1];
    }
    else if (kIsEmptyStr(_psd2_txt.text))
    {
        [MBProgressHUD showError:txt_emptyPassword2];
    }
    else if (!kStrEqual(_psd1_txt.text, _psd2_txt.text))
    {
        [MBProgressHUD showError:txt_passwordError];
    }
    else
    {
        [self changePassword];
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
