//
//  WangConst.m
//  圣魔无界
//
//  Created by 王俊钢 on 2019/6/30.
//  Copyright © 2019 a. All rights reserved.
//

#import "WangConst.h"
//发起聊天
NSString  * const getOpenChatRestrictAndInfoUrl = @"Api/Restrict/getOpenChatRestrictAndInfo";

//svip修改骚扰情况
NSString * const setVipSecretSitUrl = @"Api/users/setVipSecretSit";

//svip获取骚扰情况
NSString * const getVipSecretSitUrl = @"Api/users/getVipSecretSit";

//获取动态列表
NSString * const getDynamicListNewFiveUrl = @"Api/Dynamic/getDynamicListNewFive";

//获取用户列表
NSString * const userListNewthUrl = @"Api/index/userListNewth";

//获取昵称历史列表
NSString * const getEditnicknameListUrl = @"Api/Users/getEditnicknameList";

//修改隐私相册设置
NSString * const setSecretSitUrl = @"Api/users/setSecretSit";

//获取隐私相册情况
NSString * const getSecretSitUrl =@"Api/users/getSecretSit";

//查看用户是否设置密码
NSString * const judgePhotoPwdUrl = @"Api/users/judgePhotoPwd";

//获取消息邮票信息
NSString * const getStampPageInfoUrl = @"Api/Restrict/getStampPageInfo";

//邮票购买验证
NSString * const stamp_ioshooks = @"Api/Ping/stamp_ioshooks";

//推顶卡购买验证
NSString * const topcard_ioshooks = @"Api/Ping/topcard_ioshooks";

//使用推顶卡-推顶动态
NSString * const useTopcard = @"Api/power/useTopcard";

//获取推顶卡信息
NSString * const getTopcardPaymentRs = @"Api/Controller/getTopcardPaymentRs";

//推顶卡记录查询
NSString * const getTopcardUsedRs = @"Api/users/getTopcardUsedRs";

//推顶卡余额
NSString * const getTopcardPageInfo = @"Api/users/getTopcardPageInfo";

//推顶卡购买记录
NSString * const buyTopcardPaymentRs = @"Api/users/getTopcardPaymentRs";

//点赞记录
NSString * const getLaudListNew = @"Api/Dynamic/getLaudListNew";

//评论记录
NSString * const getCommentListNew = @"Api/Dynamic/getCommentListNew";

//礼物记录
NSString * const getRewardListNew = @"Api/Dynamic/getRewardListNew";

//动态点赞
NSString * const laudDynamicNewrd = @"Api/Dynamic/laudDynamicNewrd";

//修改隐私相册密码
NSString * const editPhotoPwd = @"Api/users/editPhotoPwd";

//设置备注
NSString * const markName = @"Api/users/markName";

//管理员备注
NSString * const editAdminmrak = @"Api/Power/editAdminmrak";

//关注用户
NSString * const setfollowOne = @"Api/friend/followOneBox";

//取消关注用户
NSString * const setoverfollow = @"Api/friend/overfollow";

//删除评论
NSString * const delComment = @"Api/Dynamic/delComment";

//充值魔豆兑换礼物魔豆
NSString * const changeexBeans = @"Api/Ping/exBeans";

//设置描述
NSString * const lmarkName = @"Api/users/lmarkName";

//大喇叭  推顶信息
NSString * const getTopcardUsedLb = @"Api/Users/getTopcardUsedLb";


@implementation WangConst


@end
