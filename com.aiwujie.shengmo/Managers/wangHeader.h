//
//  wangHeader.h
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/11.
//  Copyright © 2019 a. All rights reserved.
//

#ifndef wangHeader_h
#define wangHeader_h

//男的图标背景颜色
//#define BOYCOLOR [UIColor colorWithHexString:@"#51c3ff" alpha:1]
#define BOYCOLOR [UIColor colorWithHexString:@"#96d6ff" alpha:1]
//女的图标背景颜色
//#define GIRLECOLOR [UIColor colorWithHexString:@"#f56684" alpha:1]
#define GIRLECOLOR [UIColor colorWithHexString:@"#ffacc0" alpha:1]

//双性图标背景颜色
#define DOUBLECOLOR [UIColor colorWithHexString:@"#e7aaee" alpha:1]

//绿色图标背景颜色
#define GREENCOLORS [UIColor colorWithHexString:@"#ade489" alpha:1]

//main 紫色
//#define MainColor [UIColor colorWithHexString:@"#B73ACB" alpha:1]
#define MainColor [UIColor colorWithHexString:@"#c450d6" alpha:1]

//textColor
#define TextCOLOR [UIColor colorWithHexString:@"303030" alpha:0.8]

//发起聊天
#define getOpenChatRestrictAndInfo  @"Api/Restrict/getOpenChatRestrictAndInfo"

//SVIP修改骚扰情况
#define setVipSecretSit @"Api/users/setVipSecretSit"

//SVIP获取骚扰情况
#define getVipSecretSit @"Api/users/getVipSecretSit"

//获取动态列表
#define getDynamicListNewFive @"Api/Dynamic/getDynamicListNewFive"

//获取用户列表
#define userListNewth   @"Api/index/userListNewth"

//地图找人
#define  searchByMapNew @"Api/index/searchByMapNew"

//获取昵称历史列表
#define getEditnicknameList @"Api/Users/getEditnicknameList"

//修改隐私相册设置
#define setSecretSit @"Api/users/setSecretSit"

//获取隐私相册情况
#define getSecretSit @"Api/users/getSecretSit"

//查看用户是否设置相册密码
#define judgePhotoPwd  @"Api/users/judgePhotoPwd"

//获取消息邮票信息
#define  getStampPageInfo @"Api/Restrict/getStampPageInfo"
#endif /* wangHeader_h */
