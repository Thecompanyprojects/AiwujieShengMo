//
//  WangConst.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/30.
//  Copyright © 2019 a. All rights reserved.
//

#import "WangConst.h"

@implementation WangConst

//发起聊天
#define getOpenChatRestrictAndInfo  @"Api/Restrict/getOpenChatRestrictAndInfo"

NSString const *getOpenChatRestrictAndInfoUrl = @"Api/Restrict/getOpenChatRestrictAndInfo";

//SVIP修改骚扰情况
#define setVipSecretSit @"Api/users/setVipSecretSit"

//SVIP获取骚扰情况
#define getVipSecretSit @"Api/users/getVipSecretSit"

//获取动态列表
#define getDynamicListNewFive @"Api/Dynamic/getDynamicListNewFive"

//获取用户列表
#define userListNewth   @"Api/index/userListNewth"

//地图找人
//#define  searchByMapNew @"Api/index/searchByMapNew"
#define  searchByMapNew @"Api/index/userListNewth"

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

//关注用户
#define setfollowOne @"Api/friend/followOneBox"

//取消关注用户
#define setoverfollow @"Api/friend/overfollow"

//删除评论
#define delComment @"Api/Dynamic/delComment"

//充值魔豆兑换礼物魔豆
#define  changeexBeans @"Api/Ping/exBeans"

//设置描述
#define lmarkName @"Api/users/lmarkName"

//大喇叭 动态推顶消息
#define  getTopcardUsedLb @"Api/Users/getTopcardUsedLb"
@end
