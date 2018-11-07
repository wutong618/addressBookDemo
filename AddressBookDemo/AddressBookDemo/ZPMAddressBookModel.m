//
//  ZPMAddressBookModel.m
//  zhaopin
//
//  Created by 吴桐 on 2018/3/29.
//  Copyright © 2018年 zhaopin.com. All rights reserved.
//
#import "NSString+Extension.h"
#import "ZPMAddressBookModel.h"

@implementation ZPMAddressBookModel
-(instancetype)initWithPerson:(ABRecordRef)person{
    self = [super init];
    if (self) {
        // 设置属性值
        [self setValueWithPerson:person];
    }
    return self;
}

/**
 设置属性值
 */
- (void)setValueWithPerson:(ABRecordRef)person
{
    // 空值过滤
    if (person == NULL) {
        return;
    }
    
    //名字
    NSString* firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    //姓氏
    NSString* lastName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    //真实姓名
    if (StringNotNullAndEmpty(lastName) && StringNotNullAndEmpty(firstName)) {
        _trueName = [NSString stringWithFormat:@"%@%@",lastName,firstName].trimString;
    }
    else if(StringIsNullOrEmpty(lastName) && StringNotNullAndEmpty(firstName)){
        _trueName = firstName.trimString;
    }else{
        _trueName = lastName.trimString;
    }
    //昵称
    _nickName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonNicknameProperty))==nil?@"":CFBridgingRelease(ABRecordCopyValue(person, kABPersonNicknameProperty));
    //公司名称
    _company =  CFBridgingRelease(ABRecordCopyValue(person, kABPersonOrganizationProperty))==nil?@"":CFBridgingRelease(ABRecordCopyValue(person, kABPersonOrganizationProperty));
    //部门
    _department =  CFBridgingRelease(ABRecordCopyValue(person, kABPersonDepartmentProperty))==nil?@"":CFBridgingRelease(ABRecordCopyValue(person, kABPersonDepartmentProperty));
    //职位
    _jobtitle =  CFBridgingRelease(ABRecordCopyValue(person, kABPersonJobTitleProperty))==nil?@"":CFBridgingRelease(ABRecordCopyValue(person, kABPersonJobTitleProperty));
    //生日
    NSDate *date =  CFBridgingRelease(ABRecordCopyValue(person, kABPersonBirthdayProperty));
    if (!date) {
        _birthDay = @"";
    }else{
//        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
//        dateFormatter.dateFormat=@"yyyyMMdd";//指定转date得日期格式化形式
//        _birthDay = [dateFormatter stringFromDate:date];
        //暂时不上送生日
        _birthDay = @"";
    }
    
    //头像
    if (ABPersonHasImageData(person) == true) {
        //暂时不上传图片
//        NSData *imageData = CFBridgingRelease(ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatOriginalSize));
//        _headImageUrl = [imageData base64EncodedStringWithOptions:0];
        _headImageUrl = @"";
    }
    else{
        _headImageUrl = @"";
    }
    
    //电子邮件列表
    _contactList = [[NSMutableArray alloc]init];
    ABMultiValueRef emailRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    for (int i = 0; i < ABMultiValueGetCount(emailRef); i++)
    {
        NSString *emailContent = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emailRef, i))==nil?@"":CFBridgingRelease(ABMultiValueCopyValueAtIndex(emailRef, i));
        NSMutableDictionary *emailDic = [[NSMutableDictionary alloc]init];
        [emailDic setValue:@"1" forKey:@"contactType"];
        [emailDic setValue:emailContent forKey:@"contact"];
        [_contactList addObject:emailDic];
    }
    if (emailRef) CFRelease(emailRef);
    
    //电话列表
    ABMultiValueRef phoneRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i = 0; i < ABMultiValueGetCount(phoneRef); i++)
    {
        CFStringRef phoneLabel = ABMultiValueCopyLabelAtIndex(phoneRef, i);
        NSString *phoneLabelString = (__bridge_transfer NSString *)phoneLabel;
        if ([phoneLabelString containsString:@"钉钉"]) {
            //如果自定义标签中包含钉钉两个字，则该条数据不会上传到后台
            self.isNeedDele = YES;
        }
        
        NSString *phoneContent = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneRef, i))==nil?@"":CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneRef, i));
        if (StringNotNullAndEmpty(phoneContent)) {
            if ([phoneContent containsString:@"-"]) {
                phoneContent = [phoneContent stringByReplacingOccurrencesOfString:@"-" withString:@""];
            }
        }
        NSMutableDictionary *phoneDic = [[NSMutableDictionary alloc]init];
        [phoneDic setValue:@"0" forKey:@"contactType"];
        [phoneDic setValue:phoneContent forKey:@"contact"];
        // 添加到数组
        [_contactList addObject:phoneDic];
    }
    if (phoneRef) CFRelease(phoneRef);
}
@end
