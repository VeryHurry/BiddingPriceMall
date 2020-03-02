//
//  MineViewController.m
//  BiddingPriceMall
//
//  Created by mac on 2019/9/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MineViewController.h"
#import "UserInfoVC.h"
#import "AddressListVC.h"
#import "BankListViewController.h"
#import "SecurityCenterViewController.h"
#import "MyTeamViewController.h"
#import "PlacesRecordViewController.h"
#import "CapitalSubsidiaryViewController.h"
#import "IntegralListViewController.h"
#import "MyOrderViewController.h"

@interface MineViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *user_img;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *account;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *enableBalance;
@property (weak, nonatomic) IBOutlet UILabel *placesNum;
@property (weak, nonatomic) IBOutlet UILabel *integral;
@property (weak, nonatomic) IBOutlet UIButton *share_btn;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self isJumpLoginVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBgGray;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.share_btn.xx_touchAreaInsets = UIEdgeInsetsMake(25, 25, 25, 25);
    self.user_img.xx_cornerRadius = self.user_img.xx_height/2;
    [self.user_img xx_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        /**
         *  弹出提示框
         */
        //初始化提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //初始化UIImagePickerController
            UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
            //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
            //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
            //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
            PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //允许编辑，即放大裁剪
            PickerImage.allowsEditing = YES;
            //自代理
            PickerImage.delegate = self;
            //页面跳转
            [self presentViewController:PickerImage animated:YES completion:nil];
        }]];
        //按钮：拍照，类型：UIAlertActionStyleDefault
        [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            /**
             其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
             */
            UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
            //获取方式:通过相机
            PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
            PickerImage.allowsEditing = YES;
            PickerImage.delegate = self;
            [self presentViewController:PickerImage animated:YES completion:nil];
        }]];
        //按钮：取消，类型：UIAlertActionStyleCancel
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self updateHeadImg:newPhoto];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - network
//获取用户信息
- (void)getUserInfoMessage
{
    NSDictionary *dic = @{@"id":[kUserDefaults objectForKey:def_id]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_accountInfo andData:dic andSuccessBlock:^(id success) {
        UserModel *model = [UserModel modelWithJSON:success[@"rows"]];
        [kUserDefaults setObject:success[@"rows"] forKey:def_userModel];
        [kUserDefaults setObject:model.accountNo forKey:def_phone];
        [kUserDefaults setObject:model.ID forKey:def_id];
        [self.user_img sd_setImageWithURL:kUrl(model.headImg) placeholderImage:kImage(@"person-center_icon")];
        self.userName.text = model.userName;
        self.account.text = model.accountNo;
        self.balance.text = [NSString stringWithFormat:@"%.2f",model.balance];
        self.enableBalance.text = [NSString stringWithFormat:@"%.2f",model.enableBalance];
        self.placesNum.text = [NSString stringWithFormat:@"%.2f",model.placesNum];
        self.integral.text = [NSString stringWithFormat:@"%.2f",model.integral];
        
    } andFailureBlock:^(id failure) {
        
    }];
}

//上传头像
- (void)updateHeadImg:(UIImage *)img
{
    [MBProgressHUD showMessage:txt_upLoad toView:kWindow];
    NSData *imageData = UIImageJPEGRepresentation(img, 1);
    NSDictionary *dic = @{@"id":[kUserDefaults objectForKey:def_id]};
    [[XXNetWorkMangerBase sharedNetWorkManger] postWithUrl:api_addHeadImg imageData:imageData fileName:@"headImg" parameter:dic andSuccessBlock:^(id success) {
        [self.user_img sd_setImageWithURL:success[@"rows"][@"headImg"] placeholderImage:kImage(@"person-center_icon")];
        [MBProgressHUD hideHUDForView:kWindow];
        [MBProgressHUD showSuccess:txt_upLoadSuccess];
    } andFailureBlock:^(id failure) {
        [MBProgressHUD hideHUDForView:kWindow];
    }];
   
}

#pragma mark - button action
- (IBAction)look_action:(id)sender
{
    [self xx_pushVC:[self xx_getSb:@"Wallet" identifier:@"wallet_sb"]];
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

- (IBAction)order_action:(id)sender
{
    [self xx_pushVC:[MyOrderViewController new]];
}

- (IBAction)address_action:(id)sender
{
    [self xx_pushVC:[AddressListVC new]];
}

- (IBAction)bankCard:(id)sender
{
    [self xx_pushVC:[BankListViewController new]];
}

- (IBAction)security_action:(id)sender
{
    [self xx_pushVC:[self xx_getSb:@"SecurityCenter" identifier:@"securityCenter_sb"]];
}

- (IBAction)userInfo:(id)sender
{
    UserInfoVC *vc = [[UserInfoVC alloc]initWithTableViewStyle:UITableViewStyleGrouped];
    [self xx_pushVC:vc];
}

- (IBAction)share:(id)sender
{
    
}

- (IBAction)myTeam:(id)sender
{
    [self xx_pushVC:[MyTeamViewController new]];
}

- (IBAction)referees:(id)sender
{
    
}

- (IBAction)into:(id)sender
{
    [self xx_pushVC:[self xx_getSb:@"Wallet" identifier:@"into_sb"]];
}

- (IBAction)outGold:(id)sender
{
    [self xx_pushVC:[self xx_getSb:@"Wallet" identifier:@"out_sb"]];
}

#pragma mark - other
- (void)isJumpLoginVC
{
    if (kIsEmptyObj([kUserDefaults objectForKey:def_userModel])) {
        [self presentViewController:[self xx_getSb:@"Login" identifier:@"login_sb"] animated:YES completion:^{
            
        }];
    }
    else
    {
        [self getUserInfoMessage];
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

