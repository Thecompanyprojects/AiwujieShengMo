//
//  wangHeader.h
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/11.
//  Copyright © 2019 a. All rights reserved.
//

#ifndef wangHeader_h
#define wangHeader_h

#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

//16进制转rgb颜色的宏定义
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
////软件的版本号设置
//#define VERSION @"V2.6.6"
//获取设备的系统版本
#define PHONEVERSION [[UIDevice currentDevice] systemVersion]
//判断设备是否是iPhone X
#define ISIPHONEX [UIScreen mainScreen].bounds.size.height == 812 ? 1 : 0
//判断是否是iPhone p
#define ISIPHONEPLUS [UIScreen mainScreen].bounds.size.height == 736 ? 1 : 0
//iPhone X 顶部导航距离
#define IPHONEXTOPH 88
//iPhone X 底部触碰区距离
#define IPHONEXBOTTOMH 34
//融云客服的id
#define SERVICE_ID @"KEFU148492045558421"

//测试服务器
#define PICHEADURL  @"http://cs.shengmo.org/"

//正式服务器
//#define PICHEADURL  @"http://hao.shengmo.org:888/"

//微博的key和url
#define kAppKey         @"2758008921"
#define kRedirectURI    @"https://api.weibo.com/oauth2/default.html"
//定义广告栏的比例
#define ADVERTISEMENT [UIScreen mainScreen].bounds.size.width/3.2

//定义附近和动态处上方的榜单高度
#define DYANDNERHEIGHT [UIScreen mainScreen].bounds.size.width/4.2

//宽度的比例与5相比
#define WIDTHRADIO [UIScreen mainScreen].bounds.size.width/320

//高度的比例与5相比
#define HEIGHTRADIO [UIScreen mainScreen].bounds.size.height/568


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


//=====================单例==================
// @interface
#define singleton_interface(className) \
+ (className *)shared;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}
//========================end==================



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

//邮票购买验证
#define stamp_ioshooks @"Api/Ping/stamp_ioshooks"

//推顶卡购买验证
#define topcard_ioshooks @"Api/Ping/topcard_ioshooks"

//使用推顶卡-推顶动态
#define useTopcard @"Api/power/useTopcard"

//获取推顶卡信息
#define getTopcardPaymentRs @"Api/Controller/getTopcardPaymentRs"

//推顶卡记录查询
#define getTopcardUsedRs @"Api/users/getTopcardUsedRs"

//推顶卡余额
#define getTopcardPageInfo @"Api/users/getTopcardPageInfo"

//使用推顶
#define useTopcard  @"Api/power/useTopcard"

//推顶卡购买记录
#define buyTopcardPaymentRs  @"Api/users/getTopcardPaymentRs"

//点赞记录
#define getLaudListNew @"Api/Dynamic/getLaudListNew"

//评论记录
#define getCommentListNew @"Api/Dynamic/getCommentListNew"

//礼物记录
#define getRewardListNew @"Api/Dynamic/getRewardListNew"

//动态点赞
#define laudDynamicNewrd @"Api/Dynamic/laudDynamicNewrd"


//修改隐私相册密码
#define editPhotoPwd @"Api/users/editPhotoPwd"

//设置备注
#define markName  @"Api/users/markName"

//管理员备注
#define editAdminmrak @"Api/Power/editAdminmrak"
#endif /* wangHeader_h */
