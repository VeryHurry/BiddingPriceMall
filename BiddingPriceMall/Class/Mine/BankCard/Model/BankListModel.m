//
//Created by ESJsonFormatForMac on 19/10/23.
//

#import "BankListModel.h"
@implementation BankListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"rows" : [BankModel class]};
}


@end

@implementation BankModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


