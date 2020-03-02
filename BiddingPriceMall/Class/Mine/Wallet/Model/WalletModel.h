//
//Created by ESJsonFormatForMac on 19/10/25.
//

#import <Foundation/Foundation.h>

@class Data,Placeslist;
@interface WalletModel : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) Data *data;

@end
@interface Data : NSObject

@property (nonatomic, strong) NSArray *placesList;

@property (nonatomic, assign) CGFloat totalPrice;

@property (nonatomic, assign) CGFloat placesNum;

@property (nonatomic, assign) CGFloat integral;

@property (nonatomic, assign) CGFloat balance;

@property (nonatomic, assign) CGFloat enableBalance;

@end

@interface Placeslist : NSObject

@property (nonatomic, assign) NSInteger dynamic;

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) CGFloat newPrice;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, assign) NSInteger statically;

@property (nonatomic, copy) NSString *ticketNumber;

@property (nonatomic, assign) CGFloat placesSum;

@end

