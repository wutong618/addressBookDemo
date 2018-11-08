//
//  ZPMAddressBookService.m
//  zhaopin
//
//  Created by 吴桐 on 2018/3/29.
//  Copyright © 2018年 zhaopin.com. All rights reserved.
//

#import "ZPMAddressBookService.h"
#import "ZPMAddressBookModel.h"

@interface ZPMAddressBookService ()


@end

@implementation ZPMAddressBookService
{
    
}

+ (instancetype)sharedAddressBookService {
    static ZPMAddressBookService *addressBookService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        addressBookService = [[ZPMAddressBookService alloc]init];
    });
    
    return addressBookService;
}

/**
 获取通讯录信息

 @param succBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)getAddressBookWithSucc:(void (^)(NSArray *addressArray))succBlock
                               andFailed:(void (^)(id sender))failedBlock
{
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    ABAddressBookRef addressBookRef =  ABAddressBookCreate();
    if (authorizationStatus != kABAuthorizationStatusAuthorized) {
        // 请求授权
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            // 回调到主线程返回结果
            dispatch_async(dispatch_get_main_queue(), ^{
                //授权成功
                if (granted) {
                    NSArray *addressArray = [self matchAddressBook:addressBookRef];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (succBlock) succBlock(addressArray);
                    });
                }
                //授权失败
                else {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"345",@"code",@"邀请认证没有授权访问您的通讯录，您可以打开系统“设置>隐私>通讯录”，允许访问您的通讯录。", @"message",nil];

                    failedBlock(dict);
                }
            });
        });
    }else{
        NSArray *addressArray = [self matchAddressBook:addressBookRef];
        if (succBlock) succBlock(addressArray);
    }
}


/**
 获取通讯录信息
 
 @return 通讯录model
 */
- (NSArray *)matchAddressBook:(ABAddressBookRef)addressBook{
    CFArrayRef allPerson = NULL;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wnon-literal-null-conversion"
    allPerson = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, kABSourceTypeLocal, kABPersonSortByLastName);
    #pragma clang diagnostic pop
    // 存储通讯录的数组
    NSMutableArray *addressBookArray = [NSMutableArray array];
    
    // 循环遍历，获取每个联系人信息
    for (NSInteger i = 0; i < CFArrayGetCount(allPerson); i++)  {
        ABRecordRef person = CFArrayGetValueAtIndex(allPerson, i);
        ZPMAddressBookModel *personModel =  [[ZPMAddressBookModel alloc] initWithPerson:person];
        [addressBookArray addObject:personModel];
    }
    // 释放资源
    if (allPerson) CFRelease(allPerson);
    return addressBookArray;
}

/**
 新增通讯录信息
 */
- (void)createAddressBook{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([self existPhone:@"022-12312312"]) {
            NSLog(@"号码已存在");
            return ;
        }
        CFErrorRef error = NULL;
        //创建一个通讯录操作对象
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        //创建一条新的联系人纪录
        ABRecordRef newRecord = ABPersonCreate();
        //为新联系人记录添加属性值
        ABRecordSetValue(newRecord, kABPersonLastNameProperty, (__bridge CFTypeRef)@"xxxx官方客服 ", &error);
        //创建一个多值属性(电话)
        ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"022-12312312", kABPersonPhoneMainLabel, NULL);
        ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"12312312312", kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(newRecord, kABPersonPhoneProperty, multi, &error);
        
        //添加记录到通讯录操作对象
        ABAddressBookAddRecord(addressBook, newRecord, &error);
        //保存通讯录操作对象
        ABAddressBookSave(addressBook, &error);
        CFRelease(multi);
        CFRelease(newRecord);
        CFRelease(addressBook);
    });
}
// 指定号码是否已经存在
- (BOOL)existPhone:(NSString*)phoneNum{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef records;
    // 获取通讯录中全部联系人
    records = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    // 遍历全部联系人，检查是否存在指定号码
    for (int i=0; i<CFArrayGetCount(records); i++)
    {
        ABRecordRef record = CFArrayGetValueAtIndex(records, i);
        CFTypeRef phones = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFArrayRef phoneNums = ABMultiValueCopyArrayOfAllValues(phones);
        if (phoneNums)
        {
            for (int j=0; j<CFArrayGetCount(phoneNums); j++)
            {
                NSString *phone = (NSString*)CFArrayGetValueAtIndex(phoneNums, j);
                if ([phone isEqualToString:phoneNum])
                {
                    return YES;
                }
            }
        }
    }
    CFRelease(addressBook);
    return NO;
}
@end
