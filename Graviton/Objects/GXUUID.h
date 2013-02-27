//
//  GXUUID.h
//  Graviton
//
//  Created by Logan Collins on 11/2/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GXUUID : NSObject <NSCopying, NSSecureCoding>

/* Create a new autoreleased GXUUID with RFC 4122 version 4 random bytes */
+ (id)UUID;

/* Create a new NSUUID with RFC 4122 version 4 random bytes */
- (id)init;

/* Create an NSUUID from a string such as "E621E1F8-C36C-495A-93FC-0C247A3E6E5F". Returns nil for invalid strings. */
- (id)initWithUUIDString:(NSString *)string;

/* Create an NSUUID with the given bytes */
- (id)initWithUUIDBytes:(const uuid_t)bytes;

/* Get the individual bytes of the receiver */
- (void)getUUIDBytes:(uuid_t)uuid;

/* Return a string description of the UUID, such as "E621E1F8-C36C-495A-93FC-0C247A3E6E5F" */
- (NSString *)UUIDString;

@end
