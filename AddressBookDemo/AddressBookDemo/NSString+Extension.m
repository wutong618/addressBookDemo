//
//  NSString+Extension.m
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
- (NSString *)trimString
{
    NSString *newString = nil;
    
    if (StringNotNullAndEmpty(self)) {
        newString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    if (StringIsNullOrEmpty(newString)) {
        newString = nil;
    }
    
    return newString;
}


@end

