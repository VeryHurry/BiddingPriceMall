//
//Created by ESJsonFormatForMac on 19/10/30.
//

#import <Foundation/Foundation.h>

@class Data1,Data2;
@interface todayOrderListModel : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, assign) NSInteger total;

@end
@interface Data1 : NSObject

@property (nonatomic, assign) NSInteger shopType;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) NSInteger totalPrice;

@property (nonatomic, assign) NSInteger orderStatus;

@property (nonatomic, copy) NSString *ticketNumber;

@property (nonatomic, copy) NSString *telNo;

@property (nonatomic, copy) NSString *buyAccount;

@property (nonatomic, assign) NSInteger distributionPrice;

@property (nonatomic, copy) NSString *parentIds;

@property (nonatomic, copy) NSString *createTimeStr;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, assign) NSInteger unitPrice;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) CGFloat charge;

@property (nonatomic, copy) NSString *finishTime;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *remark;

@end

@interface Data2 : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *finishTime;

@property (nonatomic, copy) NSString *ticketNumber;

@property (nonatomic, assign) NSInteger charge;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, copy) NSString *sellAccount;

@property (nonatomic, copy) NSString *createTimeStr;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, assign) NSInteger orderStatus;

@property (nonatomic, assign) NSInteger shopType;

@property (nonatomic, assign) NSInteger distributionPrice;

@property (nonatomic, assign) NSInteger totalPrice;

@property (nonatomic, assign) NSInteger unitPrice;

@end

