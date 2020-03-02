//
//Created by ESJsonFormatForMac on 19/10/11.
//

#import <Foundation/Foundation.h>

@class Rows;
@interface GoodsListModel : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, assign) NSInteger total;

@end
@interface Rows : NSObject

@property (nonatomic, assign) NSInteger everyTimeTradeNum;

@property (nonatomic, assign) NSString *ID;

@property (nonatomic, copy) NSString *dept;

@property (nonatomic, copy) NSString *file;

@property (nonatomic, copy) NSString *titleFile;

@property (nonatomic, assign) NSInteger salesVolume;

@property (nonatomic, copy) NSString *ticketNumber;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, assign) NSInteger openPrice;

@property (nonatomic, assign) NSInteger relesePrice;

@property (nonatomic, assign) NSInteger inventory;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger distributionPrice;

@property (nonatomic, assign) NSInteger newPrice;

@property (nonatomic, copy) NSString *releseTime;

@end

