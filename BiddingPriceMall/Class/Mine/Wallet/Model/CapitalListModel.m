//
//Created by ESJsonFormatForMac on 19/10/25.
//

#import "CapitalListModel.h"
@implementation CapitalListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"rows" : [CapitalModel class]};
}


@end

@implementation CapitalModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


