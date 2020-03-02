//
//Created by ESJsonFormatForMac on 19/10/23.
//

#import <Foundation/Foundation.h>

@class TeamModel;
@interface MyTeamModel : NSObject

@property (nonatomic, assign) BOOL success;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, assign) NSInteger total;

@end
@interface TeamModel : NSObject

@property (nonatomic, copy) NSString *accountNo;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) NSInteger isLively;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *parentIds;

@property (nonatomic, assign) NSInteger placesNum;

@property (nonatomic, assign) NSInteger integral;

@property (nonatomic, assign) NSInteger userCount;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) NSInteger freezeBalance;

@property (nonatomic, assign) NSInteger holdNum;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, copy) NSString *headImg;
@end

