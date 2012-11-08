//
//  GXUUID.h
//  Graviton
//
//  Created by Logan Collins on 11/2/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GXUUID : NSObject <NSCopying, NSCoding>

+ (GXUUID *)UUID;

- (id)init;

- (id)initWithUUIDString:(NSString *)string;

- (NSString *)UUIDString;

@end
