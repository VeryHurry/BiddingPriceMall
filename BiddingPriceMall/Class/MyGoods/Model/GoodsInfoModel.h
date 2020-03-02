//
//Created by ESJsonFormatForMac on 19/10/12.
//

#import <Foundation/Foundation.h>

@class Up,Down,Result2,Middle,Result1;
@interface GoodsInfoModel : NSObject

@property (nonatomic, strong) Up *up;

@property (nonatomic, strong) Down *down;

@property (nonatomic, strong) Middle *middle;

@end
@interface Up : NSObject

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger lowPrice;

@property (nonatomic, assign) NSInteger newPrice;

@property (nonatomic, copy) NSString *increase;

@property (nonatomic, assign) NSInteger balance;

@property (nonatomic, assign) NSInteger hightPrice;

@end

@interface Down : NSObject

@property (nonatomic, strong) NSArray *result;

@end

@interface Result2 : NSObject

@property (nonatomic, copy) NSString *scuuessPrice;

@property (nonatomic, copy) NSString *closePrice;

@property (nonatomic, copy) NSString *dateStr;

@property (nonatomic, copy) NSString *openPrice;

@end

@interface Middle : NSObject

@property (nonatomic, strong) NSArray *result;

@end

@interface Result1 : NSObject

@property (nonatomic, copy) NSString *dateStr;

@property (nonatomic, assign) CGFloat totalPrice;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, assign) CGFloat unitPrice;

@end

