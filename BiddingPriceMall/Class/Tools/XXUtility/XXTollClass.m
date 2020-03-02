//
//  XXTollClass.m
//  Xiang_user
//
//  Created by 小新 on 16/7/30.
//  Copyright © 2016年 小新. All rights reserved.
//

#import "XXTollClass.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import <arpa/inet.h>
#import <net/if.h>
#import "AR_Keychain.h"
#import <sys/utsname.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

//#import <AFNetworking.h>
//#import <SDImageCache.h>
// 微信API
//#import "WXApi.h"

#define kSaveStatic [NSUserDefaults standardUserDefaults]
#define   KIsiPhoneX   ( [ UIScreen   instancesRespondToSelector:@selector ( currentMode ) ]   ?   CGSizeEqualToSize ( CGSizeMake ( 1125,   2436 ) ,   [ [ UIScreen   mainScreen ]   currentMode ] .size )   :   NO )
@interface XXTollClass()

@property(nonatomic, copy)  payBlock payBlock;

@end
@implementation XXTollClass

+(instancetype)Shared
{
    static XXTollClass *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[self alloc]init];
    });
    return _tool;
}
#pragma mark - 支付
//-(void)wxPay:(NSDictionary *)dic andBlock:(payBlock)block
//{
//    if (![WXApi isWXAppInstalled]){
//        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"支付失败！" message:@"请安装微信！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [al show];
//        return;
//    }
//
//    self.payBlock = block;
//
//    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payState:) name:@"payState" object:nil];
//    PayReq* req             = [[PayReq alloc] init];
//    req.partnerId           = [dic objectForKey:@"partnerid"];
//    req.prepayId            = [dic objectForKey:@"prepayid"];
//    req.nonceStr            = [dic objectForKey:@"noncestr"];
//    req.timeStamp           = [[dic objectForKey:@"timestamp"] intValue];
//    req.package             = [dic objectForKey:@"package"];
//    req.sign                = [dic objectForKey:@"sign"];
//
//    [WXApi sendReq:req];
//
//}
//// 支付结果回调
//-(void)payState:(NSNotification *)sender
//{
//
//    self.payBlock([sender.userInfo[@"payState"] integerValue]);
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

+ (BOOL)checkOperationAuthorizationWithUrl:(NSString *)urlString arr:(NSArray *)arr
{
    if ([arr containsObject:urlString]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL*stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address])
         {
             *stop = YES;
         }
     } ];
    return address ? address : @"0.0.0.0";
}
+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            //            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

// 获取UUID
//+ (NSString *)getUUID {

//    NSMutableDictionary *readUsernamePassword = (NSMutableDictionary *)[AR_Keychain load:KEY_USERNAME_PASSWORD];
//    NSString *userName = [readUsernamePassword objectForKey:KEY_USERNAME];
//    NSString *uuid = [readUsernamePassword objectForKey:KEY_PASSWORD];
//    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    if (userName == nil || uuid == nil) {
//        uuid = [[NSUUID UUID] UUIDString];
//        NSMutableDictionary *userNamePasswordKVPairs = [NSMutableDictionary dictionary];
//        [userNamePasswordKVPairs setObject:@"jBesteasyLive" forKey:KEY_USERNAME];
//        [userNamePasswordKVPairs setObject:uuid forKey:KEY_PASSWORD];
//        
//        [AR_Keychain save:KEY_USERNAME_PASSWORD data:userNamePasswordKVPairs];
//    }
//    
//    return uuid;
//}

//获取手机类型
+ (NSString*)iphoneType {
    
    //需要导入头文件：#import <sys/utsname.h>
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,3"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone9,4"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    
    return platform;
    
}

+ (BOOL)isIphoneX {
    BOOL isIphoneX = NO;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            isIphoneX = YES;
        }
    }
    return isIphoneX;
}


// 获取当前控制器
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    id currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}
#pragma mark - 本地数据存储
+(void)saveInMyLocalStoreForValue:(id)value atKey:(NSString *)key
{
    if (value)
    {
        [kSaveStatic setValue:value forKey:key];
        [kSaveStatic synchronize];
    }
}
+(id)getValueInMyLocalStoreForKey:(NSString *)key
{
    if ([kSaveStatic objectForKey:key])
    {
        return [kSaveStatic objectForKey:key];
    }
    return nil;
}
+(void)DeleteValueInMyLocalStoreForKey:(NSString *)key
{
    [kSaveStatic removeObjectForKey:key];
    [kSaveStatic synchronize];
}
#pragma mark -
#pragma mark - 传值
+ (void)addNoticeName:(NSString *)name object:(id)obj userInfo:(NSDictionary *)dic
{
    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:name object:obj userInfo:dic];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}
#pragma mark - 基础控件

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

// 创建按钮
+ (UIButton *)getButtonInitWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius imageName:(NSString *)imageName bgImg:(NSString *)bgimg andTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    if (cornerRadius > 0)
    {
        button.layer.cornerRadius = cornerRadius;
    }
    if (imageName)
    {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (bgimg)
    {
        [button setBackgroundImage:[UIImage imageNamed:bgimg] forState:UIControlStateNormal];
    }
    if (title)
    {
        [button setTitle:title forState:UIControlStateNormal];
    }
    button.titleLabel.font =kFont(16);
    [button setTitleColor:kColor_White forState:0];
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 水平 对齐方式
    //button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    // 垂直 对齐方式
    //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 内边距  上 左 下 右
    //button.titleEdgeInsets = UIEdgeInsetsMake(0, kScale_W(11), 0, 0);
    
    return button;
}

/** 创建标签 */
+ (UILabel*)getLabel:(CGRect)frame title:(NSString *)title font:(CGFloat )font
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
    lbl.text = title;
    lbl.font = kFont(font) ;
    lbl.textColor = [UIColor colorWithWhite:0.294 alpha:1.000];
    
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //
    //    [paragraphStyle setLineSpacing:8];//调整行间距
    //
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
    //    lbl.attributedText = attributedString;
    
    return lbl;
}
/** 创建textFiled */
+ (UITextField *)getTextFiledFrame:(CGRect)fram placeholder:(NSString *)placeholder textAlignment:(NSInteger)num
{
    UITextField *txt = [[UITextField alloc] initWithFrame:fram];
    txt.textColor = [UIColor colorWithWhite:0.294 alpha:1.000];
    txt.placeholder = placeholder;
    txt.font = [UIFont systemFontOfSize:16];
    
    if(num == 2)
    {
        txt.textAlignment = NSTextAlignmentCenter;
    }
    else if (num == 3)
    {
        txt.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        txt.textAlignment = NSTextAlignmentLeft;
    }
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    txt.leftView = leftView;
    txt.leftView.contentMode = UITextFieldViewModeAlways;
    
    return txt;
}
+(void)addBorderOnView:(UIView *)view cornerRad:(CGFloat)cornerRad lineCollor:(UIColor *)collor lineWidth:(CGFloat)lineWidth
{
    if (lineWidth)
    {
        view.layer.borderWidth = lineWidth;
    }
    if (collor)
    {
        view.layer.borderColor = collor.CGColor;
    }
    if (cornerRad)
    {
        view.layer.cornerRadius = cornerRad;
    }
    view.layer.masksToBounds = YES;
}
+(NSMutableAttributedString *)getOtherColorString:(NSString *)string Color:(UIColor *)Color font:(CGFloat)font inStr:(NSString *)instr
{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
    
    if (![XXTollClass isBlankString:instr]) {
        
        NSMutableString *temp = [NSMutableString stringWithString:instr];
        
        NSRange range = [temp rangeOfString:string];
        
        str = [[NSMutableAttributedString alloc] initWithString:temp];
        [str addAttribute:NSForegroundColorAttributeName value:Color range:range];
        if (font) {
            
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
        }
        
    }
    return str;
}
/**
 *  自动设置文本  宽 高
 *
 *  @param text     文本内容
 *  @param maxSize  最大尺寸
 *  @param fontSize 字体大小
 *
 *  @return 返回一个size
 */
+ (CGSize)calStrSize:(NSString *)text andMaxSize:(CGSize)maxSize andFontSize:(CGFloat)fontSize
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
    
}
//+ (NSString *)formateDate:(NSString *)dateString
//{
//
//    @try {
//
//        // ------实例化一个NSDateFormatter对象
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里的格式必须和DateString格式一致
//
//        NSDate * nowDate = [NSDate date];
//
//        // ------将需要转换的时间转换成 NSDate 对象
//        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
//
//        // ------取当前时间和转换时间两个日期对象的时间间隔
//        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
//
//        NSLog(@"time----%f",time);
//        // ------再然后，把间隔的秒数折算成天数和小时数：
//
//        NSString *dateStr = [[NSString alloc] init];
//
//        if (time<=60) {  //1分钟以内的
//
//            dateStr = @"刚刚";
//
//        }else if(time<=60*60){  //一个小时以内的
//
//            int mins = time/60;
//            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
//
//        }else if(time<=60*60*24){  //在两天内的
//
//            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
//            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
//            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
//
//            [dateFormatter setDateFormat:@"HH:mm"];
//            if ([need_yMd isEqualToString:now_yMd]) {
//                //在同一天
//                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
//            }else{
//                //昨天
//                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
//            }
//        }else {
//
//            [dateFormatter setDateFormat:@"yyyy"];
//            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
//            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
//
//            if ([yearStr isEqualToString:nowYear]) {
//                //在同一年
//                [dateFormatter setDateFormat:@"MM-dd"];
//                dateStr = [dateFormatter stringFromDate:needFormatDate];
//            }else{
//                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//                dateStr = [dateFormatter stringFromDate:needFormatDate];
//            }
//        }
//
//        return dateStr;
//    }
//    @catch (NSException *exception) {
//        return @"";
//    }
//}
+(BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
//设置状态栏颜色
+ (void)setStatusBarBackgroundColor:(UIColor *)color
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

+ (void)setPlaceholderWithTextField:(UITextField *)textField
{
    NSString *holderText = @"请输入";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:9]
                        range:NSMakeRange(0, holderText.length)];
    textField.attributedPlaceholder = placeholder;
}


#pragma mark -
#pragma mark - 多线程
/**
 主线程执行
 
 @param myQueue 任务
 */
+(void)GCDMainQueue:(MyQueue)myQueue
{
    if ([NSThread isMainThread])
    {
        myQueue();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            //Update UI in UI thread here
            myQueue();
        });
    }
}
+(void)GCDMoreQueueParallelProgressBlock:(MyQueue)myQueue
{
    //1.获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //2.添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    dispatch_async(queue, ^{
        
        myQueue();
        
    });
}
+ (void)GCDMoreQueueSeriesProgressBlock:(MyQueue)myQueue
{
    //创建串行队列
    dispatch_queue_t  queue= dispatch_queue_create("wendingding", NULL);
    //第一个参数为串行队列的名称，是c语言的字符串
    //第二个参数为队列的属性，一般来说串行队列不需要赋值任何属性，所以通常传空值（NULL）
    dispatch_async(queue, ^{
        
        myQueue();
        
    });
    
}
+ (void)queueGroupdoneBlock:(MyQueue)done queue:(MyQueue)queues, ...NS_REQUIRES_NIL_TERMINATION
{
    //  群组－统一监控一组任务
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t q = dispatch_queue_create("zj", DISPATCH_QUEUE_CONCURRENT);
    
    //VA_LIST 是在C语言中解决变参问题的一组宏
    va_list argList;
    
    if (queues) {
        
        // 添加第一个
        dispatch_group_async(group, q, ^{
            XXVoidBlock block = queues;
            block();
        });
        // 临时指针变量
        id temp;
        va_start(argList, queues);
        while ((temp = va_arg(argList, XXVoidBlock))) {
            // 添加任务
            // group 负责监控任务，queue 负责调度任务
            dispatch_group_async(group, q, ^{
                XXVoidBlock block = temp;
                block();
            });
        }
        va_end(argList);
    }
    
    // 监听所有任务完成 － 等到 group 中的所有任务执行完毕后，"由队列调度 block 中的任务异步执行！"
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 修改为主队列，后台批量下载，结束后，主线程统一更新UI
        done();
    });
}
#pragma mark -
#pragma mark - 时间转换
//获取当前的时间

+ (NSString*)getCurrentTimeFormatter:(NSString *)timeType
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    if ([timeType isEqualToString:@""]) {
        timeType = @"YYYY-MM-dd HH:mm:ss";
    }
    [formatter setDateFormat:timeType];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}



+ (NSString *)DateConvertTimeInterval:(NSDate *)date
{
    // 转时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeSp;
}

+ (NSString *)TimeIntervalConvertDate:(NSInteger )TimeInterval andFormatter:(NSInteger)formatter
{
    //NSString *str= TimeInterval;//时间戳
    NSTimeInterval time = TimeInterval ;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    
    if (formatter == 1)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else if(formatter == 2)
    {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}
// 日期格式转字符串
+ (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

// 字符串转日期格式
+ (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    return [self worldTimeToChinaTime:date];
}

// 将世界时间转化为中国区时间
+ (NSDate *)worldTimeToChinaTime:(NSDate *)date
{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    return localeDate;
}


+ (NSString *) compareCurrentTime:(NSString *)str
{
    
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%d天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%d月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d年前",temp];
    }
    
    return  result;
}


#pragma mark -
#pragma mark - 缓存相关
+(void)clearCache:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    //    [[SDImageCache sharedImageCache] cleanDisk];
}
+(NSString*)folderSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        //        folderSize += [[SDImageCache sharedImageCache] getSize];
        folderSize = folderSize/1000.f/1000.f;
        
        NSString *strSize = [NSString stringWithFormat:@"%.2fMb",folderSize];
        
        return strSize;
    }
    return @"0";
}
/**
 *  计算单个文件大小
 */
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
#pragma mark -
#pragma mark - 检测网络状态
/**
 *  查询网络状态
 */
+ (NSString *)getNetType
{
    
    UIApplication *application = [UIApplication sharedApplication];
    
    //    NSArray *chlidrenArray = [[[application valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    // 因此可见iPhone X的状态栏是多嵌套了一层，多取一次即可，最终适配代码为：
    NSArray *chlidrenArray;
    // 不能用 [[self deviceVersion] isEqualToString:@"iPhone X"] 来判断，因为模拟器不会返回 iPhone X
    if ([[application valueForKeyPath:@"_statusBar"] isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
        chlidrenArray = [[[[application valueForKeyPath:@"_statusBar"] valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    } else {
        chlidrenArray = [[[application valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    }
    
    NSInteger netType =0;
    
    for (id  child in chlidrenArray) {
        
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            
            netType = [[child valueForKeyPath:@"dataNetworkType"] integerValue];
            
        }
    }
    
    NSString *strNetType = nil ;
    
    switch (netType) {
        case 0:
            strNetType = @"0";
            break;
        case 1:
            strNetType = @"2G";
            break;
        case 2:
            strNetType = @"3G";
            break;
        case 3:
            strNetType = @"4G";
            break;
        case 5:
            strNetType = @"WIFI";
            break;
            
        default:
            strNetType = @"0";
            break;
    }
    
    [XXTollClass saveInMyLocalStoreForValue:strNetType atKey:kReachability];
    
    return strNetType;
}

+ (NSString * )getNetworkType{
    UIApplication *app = [ UIApplication   sharedApplication ] ;
    id statusBar = [ app   valueForKeyPath:@"statusBar" ] ;
    NSString *network = @"";
    if( KIsiPhoneX )
    {
        //          iPhone   X
        id statusBarView = [statusBar valueForKeyPath:@"statusBar" ] ;          UIView *foregroundView   =   [ statusBarView valueForKeyPath:@"foregroundView" ] ;
        NSArray *subviews = [[foregroundView subviews][2] subviews] ;
        for(id subview in subviews)
        {
            if([subview isKindOfClass:NSClassFromString( @"_UIStatusBarWifiSignalView")])
            {
                network = @"WIFI";
            }
            else if([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")])
            {
                network = [subview valueForKeyPath:@"originalText"];
                
            }
            
        }
        
    }
    else
    {//          非   iPhone   X
        UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView" ] ;
        NSArray *subviews = [foregroundView subviews] ;
        for(id subview in subviews )   {
            if([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")])
            {
                int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue] ;
                
                switch(networkType)
                {
                    case 0:
                        network = @"NONE";
                        break;
                    case 1:
                        network = @"2G";
                        break;
                    case 2:
                        network = @"3G";
                        break;
                    case 3:
                        network = @"4G";
                        break;
                    case 5:
                        network = @"WIFI";
                        break;
                    default:
                        break;
                        
                }
                
            }
            
        }
        
    }
    if([network isEqualToString:@""])
    {
        network = @"0";
    }
    return network;
    
}

#pragma mark -
#pragma mark - 网络请求
+ (AFHTTPSessionManager *)sharedManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //最大请求并发任务数
    manager.operationQueue.maxConcurrentOperationCount = 5;
    //     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    // 请求格式
    // AFHTTPRequestSerializer            二进制格式
    // AFJSONRequestSerializer            JSON
    // AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 超时时间
    manager.requestSerializer.timeoutInterval = 15.0f;
    // 设置请求头
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer  setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//     manager.responseSerializer.acceptableContentTypes = [NSSetsetWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
//    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
////    [manager.requestSerializer setValue:kLocAppVersion forHTTPHeaderField:@"app-version"];
//    [manager.requestSerializer setValue:[self iphoneType] forHTTPHeaderField:@"device-info"];
    // 返回格式
    // AFHTTPResponseSerializer           二进制格式
    // AFJSONResponseSerializer           JSON
    // AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
    // AFXMLDocumentResponseSerializer (Mac OS X)
    // AFPropertyListResponseSerializer   PList
    // AFImageResponseSerializer          Image
    // AFCompoundResponseSerializer       组合
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式 JSON
    //设置返回C的ontent-type
    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    
    return manager;
}
/**
 *  get请求
 */
+(void)getWithURL:(NSString *)url parameters:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure
{
    // 创建请求对象
    AFHTTPSessionManager *manager = [self sharedManager];
    
    //NSString *strUrl = [NSString stringWithFormat:@"%@%@",kURLMain,url];
    //    XXLog(@"GET:%@\n%@",url,params);
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSString *strError = [NSString stringWithFormat:@"错误接口---%@",error.userInfo[@"NSErrorFailingURLKey"]];
        XXLog(@"%@",strError);
        
        NSString *errStr  = [NSString stringWithFormat:@"%@",error.userInfo[@"NSLocalizedDescription"]];
        // 回调失败代码块
        failure(errStr);
        
    }];
    
}
+(void)postWithURL:(NSString *)url parameters:(id)params progress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSMutableURLRequest* formRequest = [[AFHTTPRequestSerializer serializer]requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    
    [formRequest setValue:@"application/x-www-form-urlencoded; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPSessionManager*manager = [AFHTTPSessionManager manager];
    
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
    
    [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil]];
    
    manager.responseSerializer= responseSerializer;
    
  
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 回调成功代码块
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XXLog(@"%@",error);
#if DEBUG
        // 取得错误信息
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        // 写入本地
        [data writeToFile:ErrorPath atomically:NO];
#else
#endif
        NSString *strError = [NSString stringWithFormat:@"错误接口---%@",error.userInfo[@"NSErrorFailingURLKey"]];
        XXLog(@"____%@",strError);
        NSString *errStr  = [NSString stringWithFormat:@"%@",error.userInfo[@"NSLocalizedDescription"]];
        // 回调失败代码块
        failure(errStr);
    }];
    
}
+(void)putWithURL:(NSString *)url parameters:(id)params progress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    // 创建请求对象
    AFHTTPSessionManager *manager = [self sharedManager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager PUT:url
      parameters:params
         success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
             // 回调成功代码块
             success(responseObject);
         }
         failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
             XXLog(@"%@",error);
#if DEBUG
             // 取得错误信息
             NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
             // 写入本地
             [data writeToFile:ErrorPath atomically:NO];
#else
#endif
             NSString *strError = [NSString stringWithFormat:@"错误接口---%@",error.userInfo[@"NSErrorFailingURLKey"]];
             
             // 回调失败代码块
             failure(strError);
         }];
}
// DELETE
+(void)deleteWithURL:(NSString *)url parameters:(id)params progress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    // 创建请求对象
    AFHTTPSessionManager *manager = [self sharedManager];
    [manager DELETE:url
         parameters:params
            success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                // 回调成功代码块
                success(responseObject);
            }
            failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                XXLog(@"%@",error);
#if DEBUG
                // 取得错误信息
                NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
                // 写入本地
                [data writeToFile:ErrorPath atomically:NO];
#else
#endif
                NSString *strError = [NSString stringWithFormat:@"错误接口---%@",error.userInfo[@"NSErrorFailingURLKey"]];
                
                // 回调失败代码块
                failure(strError);
            }];
}

+(void)upLoadImage:(NSData *)imgData fileName:(NSString *)fileName PostWithURL:(NSString *)url parameters:(id)params progress:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置超时时长
    manager.requestSerializer.timeoutInterval = 30.0f;
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 设置上传图片的名字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *imgName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:imgData name:fileName fileName:imgName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 回调成功代码块
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XXLog(@"********%@",error);
        // 回调失败代码块
#if DEBUG
        // 取得错误信息
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        // 写入本地
        [data writeToFile:ErrorPath atomically:NO];
#else
#endif
        NSString *strError = [NSString stringWithFormat:@"错误接口---%@",error.userInfo[@"NSErrorFailingURLKey"]];
        
        // 回调失败代码块
        failure(strError);
    }];
}

+ (void)updateFile:(NSArray*)fileData url:(NSString*)url parameters:(NSMutableDictionary*)params fileName:(NSString*)fileName viewControler:(UIViewController*)vc success:(void(^)(id result))result failure:(FailureBlock)failure;
{
    url = [NSString stringWithFormat:@"%@%@",kURLMain,url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int index = 0;
        for(UIImage *image in fileData)
        {
            NSString* tempFileName = [NSString stringWithFormat:@"%@%d.png",fileName,index];
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            [formData appendPartWithFileData:imageData name:@"file" fileName:tempFileName mimeType:@"image/png"];
            index ++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        result(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#if DEBUG
        // 取得错误信息
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        // 写入本地
        [data writeToFile:ErrorPath atomically:NO];
#else
#endif
        NSString *strError = [NSString stringWithFormat:@"错误接口---%@",error.userInfo[@"NSErrorFailingURLKey"]];
        
        // 回调失败代码块
        failure(strError);
    }];
}
#pragma mark -

#pragma mark - 中文转码
+ (NSString *)stringByReplacingPercentEscapesUsingEncoding:(NSString *)str
{
    NSString *strNew = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return strNew;
}
#pragma mark -
#pragma mark - MD5加密
/**
 *  把字符串加密成32位小写md5字符串
 *
 *  @param inPutText 需要被加密的字符串
 *
 *  @return 加密后的32位小写md5字符串
 */
+ (NSString*)md532BitLower:(NSString *)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[16];
    int len = [[NSString stringWithFormat:@"%ld",strlen(cStr)] intValue];
    CC_MD5( cStr,len, result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
/**
 *  把字符串加密成32位大写md5字符串
 *
 *  @param inPutText 需要被加密的字符串
 *
 *  @return 加密后的32位大写md5字符串
 */
+ (NSString*)md532BitUpper:(NSString*)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[16];
    int len = [[NSString stringWithFormat:@"%ld",strlen(cStr)] intValue];
    CC_MD5( cStr, len, result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}
#pragma mark -
#pragma mark - 数据类型转换
+ (NSString *)getJsonArray:(NSArray *)arr
{
    NSError *error = nil;
    //NSJSONWritingPrettyPrinted:指定生成的JSON数据应使用空格旨在使输出更加可读。如果这个选项是没有设置,最紧凑的可能生成JSON表示。
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil)
    {
        //NSLog(@"Successfully serialized the dictionary into data.");
        //NSData转换为String
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"JSON String = %@", jsonString);
        return jsonString;
    }
    else if ([jsonData length] == 0 &&
             error == nil)
    {
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil)
    {
        NSLog(@"An error happened = %@", error);
    }
    return @"111";
    
}
// 字典转JSON
+(NSString *)getJsonDictionary:(NSDictionary *)dic
{
    NSError *error = nil;
    //NSJSONWritingPrettyPrinted:指定生成的JSON数据应使用空格旨在使输出更加可读。如果这个选项是没有设置,最紧凑的可能生成JSON表示。
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil)
    {
        //NSData转换为String
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    else if ([jsonData length] == 0 &&
             error == nil)
    {
        NSLog(@"No data was returned after serialization.");
    }
    else if (error != nil)
    {
        NSLog(@"An error happened = %@", error);
    }
    return @"111";
}
/*
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if ([[jsonString class] isSubclassOfClass:[NSString class]])
    {
        if (jsonString == nil) {
            return nil;
        }
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
    }
    else
    {
        return nil;
    }
}
+ (NSDictionary *)dictionaryWithData:(NSData *)data
{
    
    if (data == nil) {
        return nil;
    }
    
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    if(arabicNum == 0)
    {
        return @"零";
    }
    else if (arabicNum < 20 && arabicNum > 9)
    {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }
    else
    {
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

#pragma mark -
#pragma mark - 数据类型判断
// 是否包含表情判断
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
// 判断面是否是6-18位字符串
+(BOOL)isPassword:(NSString *)password
{
    NSString *passwordRegex = @"^([0-9a-zA-z]){6,18}";
    NSPredicate *range = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [range evaluateWithObject:password];
}
/** 判断手机号码 */
+ (BOOL)isTelphoneNum:(NSString *)phoneText
{
    NSString *telRegex = @"^1[34578]\\d{9}$";
    NSPredicate *prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    return [prediate evaluateWithObject:phoneText];
}
/** 判断是否为整形 */
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
/** 判断是否包含中文 */
+ (BOOL)isValidatePassword:(NSString *)password
{
    // 只需要不是中文即可
    NSString *regex = @".{0,}[\u4E00-\u9FA5].{0,}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",regex];
    BOOL res = [predicate evaluateWithObject:password];
    if (res == TRUE) {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}
// 身份证识别
+(BOOL)isIDCard:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}
#pragma mark - 硬件设备相关
/**
 打电话
 
 @param num 电话号码
 */
+(void)callWithPhoneNum:(NSString *)num
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",num];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

/**
 闪光灯操作
 
 @param state YES 开  NO关
 */
+(void)flashlightTorchMode:(BOOL)state
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) { // 判断是否有闪光灯
            // 请求独占访问硬件设备
            [device lockForConfiguration:nil];
            if (state)
            {
                [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
            }else
            {
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
            }
            // 请求解除独占访问硬件设备
            [device unlockForConfiguration];
        }
    }
    
}
#pragma mark -
@end




