//
//Created by ESJsonFormatForMac on 19/10/25.
//

#import "WalletModel.h"
@implementation WalletModel


@end

@implementation Data

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"placesList" : [Placeslist class]};
}


@end


@implementation Placeslist


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


