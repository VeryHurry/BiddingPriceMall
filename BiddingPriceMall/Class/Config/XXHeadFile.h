

#ifndef XXHeadFile_h
#define XXHeadFile_h

#import "XXMacro.h"

#import "NSArray+XXArray.h"
#import "NSDictionary+XXDictionary.h"
#import "NSString+XXString.h"
#import "UIView+XXView.h"
#import "UILabel+XXLabel.h"
#import "UIButton+XXButton.h"
#import "UIImageView+XXImageView.h"
#import "UIImage+XXImage.h"
#import "UIColor+XXColor.h"
#import "UITableView+XXTableView.h"
#import "UIViewController+XXViewController.h"
#import "UIAlertView+XXAlertView.h"
#import "UITabBar+XXTabBar.h"
#import "NSString+XXString.h"
#import "XXTollClass.h"


typedef void(^XXObjBlock)(id obj);
typedef void(^XXDictionaryBlock)(NSDictionary *dic);
typedef void(^XXNSArrayBlock)(NSArray *arr);
typedef void(^XXBOOLBlock)(BOOL isTrue);
typedef void(^XXIntegerBlock)(NSInteger num);
typedef void(^XXFloatBlock)(CGFloat num);
typedef void(^XXVoidBlock)();


#endif /* XXHeadFile_h */
