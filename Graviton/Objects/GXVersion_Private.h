//
//  GXVersion_Private.h
//  Graviton
//
//  Created by Logan Collins on 6/18/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import <Graviton/GXVersion.h>


@interface GXVersion ()

- (id)initWithString:(NSString *)string;

@property (nonatomic, copy, readwrite) NSString *releaseString;
@property (nonatomic, copy, readwrite) NSString *prereleaseString;
@property (nonatomic, readwrite) GXVersionReleaseType releaseType;

@end
