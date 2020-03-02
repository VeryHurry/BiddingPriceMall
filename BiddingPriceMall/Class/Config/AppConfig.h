
#ifndef AppConfig_h
#define AppConfig_h


#endif /* AppConfig_h */

// APP对外版本号
#define kLocAppVersion @"2.1.0"

//公用Block
typedef void(^voidBlock)();
typedef void(^idBlock)(id obj);
typedef void(^stringBlock)(NSString *result);
typedef void(^stringBlock2)(NSString *result,NSString *description);
typedef void(^boolBlock)(BOOL boolen);
typedef void(^errorBlock)(NSError *error);
typedef void(^numberBlock)(NSNumber *result);
typedef void(^arrayWithErrorBlock)(NSArray *results,NSError *error);
typedef void(^arrayAndDescription)(NSArray *results,NSString *description);
typedef void(^arrayBlock)(NSArray *results);
typedef void(^successBlock)(id resultObj);


// 沙盒存储 键
static NSString * const def_userModel = @"userModel";
static NSString * const def_id = @"id";
static NSString * const def_phone = @"phone";
static NSString * const def_password = @"password";


//是不是iOS11
#define isIos11 @available(iOS 11.0, *)
//是不是IphoneX
#define isPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


// 提示文本
static NSString * const txt_networkError = @"网络断开，同步失败";
static NSString * const txt_netError = @"网络错误";
static NSString * const txt_loding = @"加载中...";
static NSString * const txt_uploading = @"上传中...";
static NSString * const txt_saveSuc = @"保存成功";
static NSString * const txt_saveFil = @"保存失败";
static NSString * const txt_stayTunedFor = @"敬请期待";

static NSString * const txt_emptyPhone = @"请先输入手机号码";
static NSString * const txt_phoneError = @"请输入正确的手机号码";
static NSString * const txt_emptyName = @"请先输入真实姓名";
static NSString * const txt_emptyPassword1 = @"请先输入密码";
static NSString * const txt_emptyPassword2 = @"请先确认密码";
static NSString * const txt_passwordError = @"密码不一致";
static NSString * const txt_emptyCode = @"请先输入验证码";
static NSString * const txt_codeError = @"请输入正确的验证码";
static NSString * const txt_emptyId = @"请先输入证件号码";
static NSString * const txt_idError = @"请输入正确的证件号码";
static NSString * const txt_agree = @"请先同意《风险告知书》《交易规则》";
static NSString * const txt_register = @"注册成功";
static NSString * const txt_login = @"登录成功";
static NSString * const txt_logout = @"退出登录成功";

static NSString * const txt_upLoad = @"上传中...";
static NSString * const txt_upLoadSuccess = @"上传成功";
static NSString * const txt_tip = @"提示";
static NSString * const txt_deleteAddress = @"确定要删除该地址吗？";
static NSString * const txt_deleteBank = @"确定要解绑该银行卡吗？";

static NSString * const txt_codeType1 = @"注册用户";
static NSString * const txt_codeType2 = @"重置密码";
static NSString * const txt_logining = @"登录中...";
static NSString * const txt_registing = @"注册中...";
static NSString * const txt_reseting = @"重置中...";

static NSString * const txt_loginSuccess = @"登录成功";
static NSString * const txt_loginFailure = @"账号或密码错误，请重新输入";
static NSString * const txt_modifySuccess = @"修改成功";
static NSString * const txt_modifyFailure = @"修改失败";
static NSString * const txt_registSuccess = @"注册成功";
static NSString * const txt_registFailure = @"注册失败";
static NSString * const txt_bindSuccess = @"绑定成功";
static NSString * const txt_inputCode = @"请输入正确的验证码";

static NSString * const txt_photo = @"请先选择照片";
static NSString * const text_updatePhoto = @"图片上传中";
static NSString * const text_errorUpdatePhoto = @"图片上传失败，请查收服务器";
static NSString * const txt_headUp = @"头像上传中";





#define kSecret @"$2a$10$G5TwJyHGvuFzM7H9V6zAl.d6TalQZNQ8X.D3Rp31/IKP"
#define kClientId @"clientapp"
#define kToken      [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:@"access_token"]]

#define kUid        [UserInfoManage sharedInstance].userModel.ID
#define kPhone      [UserInfoManage sharedInstance].userModel.phone
#define kCompanyId  [UserInfoManage sharedInstance].userModel.companyId
#define kPassportId [UserInfoManage sharedInstance].userModel.passportId
#define kHead      [UserInfoManage sharedInstance].userModel.headPortrait
#define kUserLabel  [UserInfoManage sharedInstance].userModel.label

#define kAPPId  @"1276460060"

// 网络状态码
#define kNetStatue [success[@"code"] integerValue]


// 字体
#define kFont_Medium(x) [UIFont fontWithName:@"HelveticaNeue-Medium" size:x]
#define kFont_Bold(x) [UIFont systemFontOfSize:x weight:UIFontWeightBold]
#define kFont_Regular(x) [UIFont fontWithName:@".HelveticaNeueInterface-Regular" size:x]
#define kFont_Heavy(x) [UIFont fontWithName:@".HelveticaNeueInterface-Heavy" size:x]
#define kFont_Light(x) [UIFont fontWithName:@"PingFang-SC-Light" size:x]
// 手机系统版本
#define KSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define kAppVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 当前屏幕宽
#define ScreenWidth   ([UIScreen mainScreen].bounds.size.width)

// 当前屏幕高
#define ScreenHeight  ([UIScreen mainScreen].bounds.size.height)

//APP导航栏字体颜色
#define AppNavTitleColor  kBlackColor

//APP主题颜色
#define AppColor  [UIColor colorWithHexString:[AppConfig new].appColor]

//APP导航栏背景颜色
#define AppNavBarColor  [UIColor colorWithRed:250/255.0 green:227/255.0 blue:111/255.0 alpha:1.0]

//APP导航栏返回按钮图片
#define kDefaultBackImageName @"backImage"

//自定义颜色
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(1)];
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)];
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//提示文字
#define NoneDataTip @""

//keyWindow实例化
#define kWindow [UIApplication sharedApplication].keyWindow

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//重定义打印方法
#ifdef DEBUG
#define CLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define CLog(format, ...)
#endif

//设置（方正黑体简体字体）字体大小
#define FONT(F)  [UIFont systemFontOfSize:F]
//[UIFont fontWithName:@"FZHTJW--GB1-0" size:F]
#define BOLDFONT(F)  [UIFont boldSystemFontOfSize:F]

//获取图片资源
#define JLGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)

//弱引用/强引用
#define JLWeakSelf(type)  __weak typeof(type) weak##type = type;
#define JLStrongSelf(type)  __strong typeof(type) type = weak##type;

/**
 获取当前语言
 */
#define LRCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

/**
 设置 view 圆角和边框
 */
#define JLViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

/**
 由角度转换弧度 由弧度转换角度
 */
#define JLDegreesToRadian(x) (M_PI * (x) / 180.0)
#define JLRadianToDegrees(radian) (radian*180.0)/(M_PI)


/**
 使用 ARC 和 MRC
 */
#if __has_feature(objc_arc)
// ARC
#else
// MRC
#endif


/**
 判断是真机还是模拟器
 */
// 判断是不是iOS系统，如果是iOS系统在真机和模拟器输出都是YES
#if TARGET_OS_IPHONE
#endif
#if (TARGET_IPHONE_SIMULATOR)
// 在模拟器的情况下
#else
// 在真机情况下
#endif


/**
 沙盒目录文件
 */
//获取temp
#define kPathTemp NSTemporaryDirectory()

//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]


/**
 GCD 的宏定义
 */
//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);

#define ScrenScale [UIScreen mainScreen].bounds.size.width/375.0
#define ScrenScaleHeight [UIScreen mainScreen].bounds.size.height/667.0
#define WeakSelf __weak typeof(self) weakSelf = self;


// Keychain
static NSString * const KEY_USERNAME_PASSWORD = @"com..app.usernamepassword";
static NSString * const KEY_USERNAME = @"com..app.username";
static NSString * const KEY_PASSWORD = @"com..app.password";
