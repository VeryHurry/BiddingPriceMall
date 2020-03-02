//
//Created by ESJsonFormatForMac on 19/10/22.
//

#import "AddressListModel.h"
@implementation AddressListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"rows" : [AddressModel class]};
}


@end

@implementation AddressModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


