//
//  NSString+Extension.h
//
//

#import <Foundation/Foundation.h>
#define UIKIT_STATIC_INLINE    static inline
/**
 判断字符串为空或者为空字符串
 @param str : 要判断的字符串
 @return 返回BOOL表示结果
 */
UIKIT_STATIC_INLINE BOOL StringIsNullOrEmpty(NSString* str)
{
	return (![str isKindOfClass:[NSString class]] || str == nil || [str isEqualToString:@""] || str.length == 0);
}
/**
 判断字符串不为空并且不为空字符串
 @param str : 要判断的字符串
 @return 返回BOOL表示结果
 */
UIKIT_STATIC_INLINE BOOL StringNotNullAndEmpty(NSString* str)
{
	return (str != nil && [str isKindOfClass:[NSString class]] && ![str isEqualToString:@""] && str.length > 0);
}
@interface NSString (Extension)
- (NSString *)trimString;
@end
