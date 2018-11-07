//
//  ZPMAddressBookModel.h
//  zhaopin
//
//  Created by 吴桐 on 2018/3/29.
//  Copyright © 2018年 zhaopin.com. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <Foundation/Foundation.h>

@interface ZPMAddressBookModel : NSObject
@property (nonatomic, strong) NSString *trueName;           //真实名字
@property (nonatomic, strong) NSString *nickName;           //昵称
@property (nonatomic, strong) NSString *company;            //公司名称
@property (nonatomic, strong) NSString *department;         //部门
@property (nonatomic, strong) NSString *jobtitle;           //职位
@property (nonatomic, strong) NSString *note;               //备注
@property (nonatomic, strong) NSString *birthDay;           //生日
@property (nonatomic, strong) NSString *headImageUrl;       //头像
@property (nonatomic, strong) NSMutableArray  *contactList;  //电话列表
@property (nonatomic, assign) BOOL isNeedDele;             //是否需要删除

-(instancetype)initWithPerson:(ABRecordRef)person;
@end

