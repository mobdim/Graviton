//
//  GXOrdinalNumberFormatter.m
//  Graviton
//
//  Created by Logan Collins on 2/14/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import "GXOrdinalNumberFormatter.h"


static NSString * GXOrdinalNumberFormatterDefaultOrdinalIndicator = @".";


@implementation GXOrdinalNumberFormatter- (id)init {
    self = [super init];
    if (self) {
        [self setNumberStyle:NSNumberFormatterNoStyle];
        [self setAllowsFloats:NO];
        [self setGeneratesDecimalNumbers:NO];
        [self setRoundingMode:NSNumberFormatterRoundFloor];
        [self setMinimum:[NSNumber numberWithInteger:0]];
        [self setLenient:YES];
    }
    return self;
}

- (NSString *)stringFromNumber:(NSNumber *)number {
    NSString *indicator = self.ordinalIndicator;
    if (indicator == nil) {
        indicator = [self localizedOrdinalIndicatorStringFromNumber:number];
    }
    
    [self setPositivePrefix:nil];
    [self setPositiveSuffix:nil];
    
    NSString *languageCode = [[self locale] objectForKey:NSLocaleLanguageCode];
    if ([languageCode isEqualToString:@"zh"]) {
        [self setPositivePrefix:indicator];
    }
    else {
        [self setPositiveSuffix:indicator];
    }
    
    return [super stringFromNumber:number];
}


#pragma mark -
#pragma mark Locale-specific formatting

- (NSString *)localizedOrdinalIndicatorStringFromNumber:(NSNumber *)number {
    NSString *languageCode = [[self locale] objectForKey:NSLocaleLanguageCode];
    if ([languageCode isEqualToString:@"en"]) {
        return [self enOrdinalIndicatorStringFromNumber:number];
    }
    else if ([languageCode isEqualToString:@"fr"]) {
        return [self frOrdinalIndicatorStringFromNumber:number];
    }
    else if ([languageCode isEqualToString:@"nl"]) {
        return [self nlOrdinalIndicatorStringFromNumber:number];
    }
    else if ([languageCode isEqualToString:@"it"]) {
        return [self itOrdinalIndicatorStringFromNumber:number];
    }
    else if ([languageCode isEqualToString:@"pt"]) {
        return [self ptOrdinalIndicatorStringFromNumber:number];
    }
    else if ([languageCode isEqualToString:@"es"]) {
        return [self esOrdinalIndicatorStringFromNumber:number];
    }
    else if ([languageCode isEqualToString:@"ga"]) {
        return [self gaOrdinalIndicatorStringFromNumber:number];
    }
    else if ([languageCode isEqualToString:@"ja"]) {
        return [self jaOrdinalIndicatorStringFromNumber:number];
    }
    else if ([languageCode isEqualToString:@"zh"]) {
        return [self zhHansOrdinalIndicatorStringFromNumber:number];
    }
    else {
        return GXOrdinalNumberFormatterDefaultOrdinalIndicator;
    }
}

- (NSString *)deOrdinalIndicatorStringFromNumber:(NSNumber *)number {
	return @".";
}

- (NSString *)enOrdinalIndicatorStringFromNumber:(NSNumber *)number {
	NSInteger value = [number integerValue];
	NSString *suffix = @"";
	if (value > 0) {
		switch (value % 10) {
			case 1: suffix = @"st"; break;
			case 2: suffix = @"nd"; break;
			case 3: suffix = @"rd"; break;
			default: suffix = @"th"; break;
		}
		if (value % 100 >= 11 && value % 100 <= 13)  {
			suffix = @"th"; // Handle 11-13
        }
    }
	return suffix;
}

- (NSString *)esOrdinalIndicatorStringFromNumber:(NSNumber *)number {
    switch (self.grammaticalGender) {
        case GXOrdinalNumberFormatterGrammaticalGenderMale:
            return @".o";
        case GXOrdinalNumberFormatterGrammaticalGenderFemale:
            return @".a";
        default:
            return GXOrdinalNumberFormatterDefaultOrdinalIndicator;
    }
}

- (NSString *)frOrdinalIndicatorStringFromNumber:(NSNumber *)number {
    NSUInteger ulp = [number integerValue] % 10;
    switch (ulp) {
        case 1:
            switch (self.grammaticalGender) {
                case GXOrdinalNumberFormatterGrammaticalGenderMale:
                    return @"er";
                case GXOrdinalNumberFormatterGrammaticalGenderFemale:
                    return @"ère";
                default:
                    return @"er";
            }
        default:
            return @"eme";
    }
}

- (NSString *)gaOrdinalIndicatorStringFromNumber:(NSNumber *)number {
    return @"ú";
}

- (NSString *)itOrdinalIndicatorStringFromNumber:(NSNumber *)number {
    switch (self.grammaticalGender) {
        case GXOrdinalNumberFormatterGrammaticalGenderMale:
            return @".o";
        case GXOrdinalNumberFormatterGrammaticalGenderFemale:
            return @".a";
        default:
            return GXOrdinalNumberFormatterDefaultOrdinalIndicator;
    }
}

- (NSString *)jaOrdinalIndicatorStringFromNumber:(NSNumber *)number {
    return @"番";
}

- (NSString *)nlOrdinalIndicatorStringFromNumber:(NSNumber *)number {
    return @"e";
}

- (NSString *)ptOrdinalIndicatorStringFromNumber:(NSNumber *)number {
    switch (self.grammaticalGender) {
        case GXOrdinalNumberFormatterGrammaticalGenderMale:
            return @".o";
        case GXOrdinalNumberFormatterGrammaticalGenderFemale:
            return @".a";
        default:
            return GXOrdinalNumberFormatterDefaultOrdinalIndicator;
    }
}

- (NSString *)zhHansOrdinalIndicatorStringFromNumber:(NSNumber *)number {
    return @"第";
}

@end