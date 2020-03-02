//
//Created by ESJsonFormatForMac on 19/10/10.
//

#import "NoticeListModel.h"
@implementation NoticeListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"rows" : [NoticeModel class]};
}


@end

@implementation NoticeModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


