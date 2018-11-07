//
//  ZPMAddressBookService.h
//  zhaopin
//
//  Created by 吴桐 on 2018/3/29.
//  Copyright © 2018年 zhaopin.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPMAddressBookService : NSObject

+ (instancetype)sharedAddressBookService;

/**
 获取通讯录信息
 
 @param succBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)getAddressBookWithSucc:(void (^)(NSArray *addressArray))succBlock
                     andFailed:(void (^)(id sender))failedBlock;

/**
新增通讯录信息
 */
- (void)createAddressBook;
@end
