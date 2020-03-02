//
//Created by ESJsonFormatForMac on 19/10/22.
//

#import <Foundation/Foundation.h>

@class AddressModel;
@interface AddressListModel : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray *rows;

@property (nonatomic, assign) NSInteger total;

@end
@interface AddressModel : NSObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) long long accountId;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, assign) NSInteger defaultAddress;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *usreName;

@end

