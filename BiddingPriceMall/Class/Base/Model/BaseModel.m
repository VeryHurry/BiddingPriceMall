//
//  BaseModel.m
//  CloudDecorate
//
//  Created by 郑少钦 on 2017/4/28.
//  Copyright © 2017年 com.1jbest.www. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(id) initWithDictionary:(NSDictionary*) jsonObject {
    if((self = [super init])) {
        [self setValuesForKeysWithDictionary:jsonObject];
    }
    return self;
    
}

+ (id)modelWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([value isKindOfClass:[NSNull class]]) {
        
        value = @"";
    }
    if (value == nil) {
        
        value = @"";
    }
    
    
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
