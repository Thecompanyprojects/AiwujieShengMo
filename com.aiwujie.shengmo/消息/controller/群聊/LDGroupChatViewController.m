//
//  LDGroupChatViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/20.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGroupChatViewController.h"
#import "LDGroupAtPersonViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDGroupInformationViewController.h"
#import "LDLookOtherGroupInformationViewController.h"
#import "XYgiftgroupMessageCell.h"
#import "XYgiftMessageContent.h"
#import "LDMyWalletPageViewController.h"
#import "SendNav.h"
#import "SendredsViewController.h"
#import "XYredMessageCell.h"
#import "XYredMessageContent.h"
#import "WSRedPacketView.h"
#import "WSRewardConfig.h"
#import "FlowFlower.h"
#import "XYreadoneCell.h"
#import "XYreadoneContent.h"
#import "NTImageBrowser.h"
#import "LDMemberViewController.h"

//照片选择
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "groupinfoModel.h"


@interface LDGroupChatViewController ()<RCPluginBoardViewDelegate,RCIMReceiveMessageDelegate,TZImagePickerControllerDelegate>
//礼物界面
@property (nonatomic,strong) GifView *gif;
@property (nonatomic,assign) BOOL isgif;

/**
 创建礼物掉落的效果
 */
//创建礼物下落的定时器
@property (nonatomic,strong) NSTimer * gifTimer;
//掉落礼物的view
@property (nonatomic,strong) FlowFlower *flowFlower;
//存储选中的礼物
@property (nonatomic,strong) UIImage *gifImage;
//掉落的时间
@property (nonatomic,assign) int second;
@property (nonatomic,copy) NSString *sendimgUrl;

@property (nonatomic,assign) NSInteger messageId;
@property (nonatomic,assign) BOOL isadmin;
@property (nonatomic,strong) groupinfoModel *infoModel;
@end

@implementation LDGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getgroupinfo];
    
    //注册自定义消息Cell
    [self registerClass:[XYgiftgroupMessageCell class] forMessageClass:[XYgiftMessageContent class]];
    [self registerClass:[XYredMessageCell class] forMessageClass:[XYredMessageContent class]];
    [self registerClass:[XYreadoneCell classForKeyedArchiver] forMessageClass:[XYreadoneContent class]];
    
    [self createRefreshUserData:self.groupId];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createButton];
    
   
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    
//    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];
//    [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];
    //根据tag删除
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1101];
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1102];
    [self addredEnvelope];
}

/**
 聊天页面发红包 礼物  闪照
 */
-(void)addredEnvelope
{
    self.chatSessionInputBarControl.pluginBoardView.pluginBoardDelegate = self;
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"聊天-礼物"] title:@"礼物" atIndex:6 tag:2001];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"聊天-红包"] title:@"红包" atIndex:7 tag:2002];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"闪照"] title:@"闪照" atIndex:8 tag:2003];
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag
{
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    if (tag==2001) {
        //红包功能
        self.isgif = YES;
        _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andisMine:NO :^{
            LDMyWalletPageViewController *cvc = [[LDMyWalletPageViewController alloc] init];
            cvc.type = @"0";
            [self.navigationController pushViewController:cvc animated:YES];
            
        }];
        [_gif getPersonUid:self.groupId andSign:@"赠送给某人"andUIViewController:self];
        
        __weak typeof (self) weakSelf = self;
        
        _gif.sendmessageBlock = ^(NSDictionary *dic) {
            NSString *imagename = [dic objectForKey:@"image"];

            NSDictionary *para = @{@"number":dic[@"num"],@"imageName":imagename};
            XYgiftMessageContent *addcontent = [XYgiftMessageContent messageWithDict:para];
            addcontent.number = dic[@"num"];
            addcontent.imageName = dic[@"image"];
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:0 error:0];
            NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [weakSelf sendMessage:addcontent pushContent:dataStr];
        };
        [self.tabBarController.view addSubview:_gif];
    }
    if (tag==2002) {
        
        self.isgif = NO;
        
        SendredsViewController * allTicketVC = [[SendredsViewController alloc] init];// 包装一个导航栏控制器
        SendNav * nav = [[SendNav alloc]initWithRootViewController:allTicketVC];
        allTicketVC.myBlock = ^(NSDictionary * _Nonnull dic) {
            __weak typeof (self) weakSelf = self;
            
            NSString *message = [dic objectForKey:@"message"];
            if (message.length==0) {
                message = @"恭喜发财，大吉大利";
            }
            NSDictionary *paras = @{@"message":message,@"extra":@"0"};
            
            XYredMessageContent *addcontent = [[XYredMessageContent alloc] init];
            addcontent.message = message;
            addcontent.senderUserInfo = [RCIM sharedRCIM].currentUserInfo;
            addcontent.extra = @"0";
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paras options:0 error:0];
            NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [weakSelf sendMessage:addcontent pushContent:dataStr];

        };
        [self presentViewController:nav animated:YES completion:nil];
    }
    if (tag==2003) {
        //阅后即焚
        self.isgif = YES;
        self.sendimgUrl = [NSString new];
        TZImagePickerController *imagePC=[[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
        [imagePC setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
            
            
            
        }];
        [self presentViewController:imagePC animated:YES completion:^{
            
        }];
    }
}


#pragma mark - 撤回消息

- (NSArray<UIMenuItem *> *)getLongTouchMessageCellMenuList:(RCMessageModel *)model{
    
    NSMutableArray<UIMenuItem *> *menuList = [[super getLongTouchMessageCellMenuList:model] mutableCopy];
    if (self.isadmin) {
        UIMenuItem *withdrawItem = [[UIMenuItem alloc] initWithTitle:@"管理员撤回" action:@selector(withdrawMenuItem)];
        [menuList addObject:withdrawItem];
        self.messageId = model.messageId;
    }
    return menuList;
}

- (void)withdrawMenuItem{
    //该方法必须是存在的方法不然无法显示出menu
    [self recallMessage:self.messageId];
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view
{
    [super didLongTouchMessageCell:model inView:view];
    if ([model.objectName isEqualToString:@"ec:messagereadone"]) {

    }
}

/**
 * 重写方法，过滤消息或者修改消息
 *
 * @param messageCotent 消息内容
 *
 * @return 返回消息内容
 */
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent{
    [super willSendMessage:messageCotent];
    
    if (!self.isgif) {
        RCTextMessage *message = (RCTextMessage *)messageCotent;
        message.extra = @"0";
        return message;
    }
    return messageCotent;
}

- (void)didTapMessageCell:(RCMessageModel *)model
{
    [super didTapMessageCell:model];
    if ([model.objectName isEqualToString:@"ec:groupgiftinfo"]) {
        //礼物
        _gifTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        //face
        
        XYgiftMessageContent *oldHongBao = (XYgiftMessageContent *)model.content;
        
        UIImage *faceImage = [UIImage imageNamed:oldHongBao.imageName];
        [[NSRunLoop currentRunLoop] addTimer:_gifTimer forMode:NSRunLoopCommonModes];
        //飞行
        _flowFlower = [FlowFlower flowerFLow:@[faceImage]];
        [_flowFlower startFlyFlowerOnView:self.view];
    }
    
    if ([model.objectName isEqualToString:@"ec:groupenvelopeinfo"]) {
        //红包
        XYredMessageContent *mes = [[XYredMessageContent alloc] init];
        mes.senderUserInfo = [RCIM sharedRCIM].currentUserInfo;
        mes.extra = @"1";
        
        mes.extra = [NSString stringWithFormat:@"1/%@",model.messageUId];
        
        RCMessage *oldMess = [[RCIMClient sharedRCIMClient] getMessageByUId:model.messageUId];
        [[RCIMClient sharedRCIMClient] setMessageExtra:oldMess.messageId value:mes.extra];
        
        for (RCMessageModel *model in self.conversationDataRepository) {
            
            if (model.messageId == oldMess.messageId) {
                if (model.messageId == oldMess.messageId) {
                    XYredMessageContent *oldHongBao = (XYredMessageContent *)model.content;
                    oldHongBao.extra = mes.extra;
                    model.content = oldHongBao;
                }
            }
        }
        
        [self.conversationMessageCollectionView reloadData];
        
        XYredMessageContent *cons = (XYredMessageContent*)model.content;
        NSString *messge = cons.message;
        
        WSRewardConfig *info = ({
            WSRewardConfig *info = [[WSRewardConfig alloc] init];
            info.money = 100.0;
            info.headImgurl = model.userInfo.portraitUri;
            info.content = messge;
            info.userName = model.userInfo.name;
            info;
        });
        
        [WSRedPacketView showRedPackerWithData:info cancelBlock:^{
            NSLog(@"取消领取");
        } finishBlock:^(float money) {
            NSLog(@"领取金额：%f",money);
        }];
        
    }
    if ([model.objectName isEqualToString:@"ec:messagereadone"]) {
        
        XYreadoneContent *content = (XYreadoneContent*)model.content;
        [[NTImageBrowser sharedShow] showImageBrowserWithImageView:content.imageUrl];

        XYreadoneContent *mes = [[XYreadoneContent alloc] init];
        mes.senderUserInfo = [RCIM sharedRCIM].currentUserInfo;
        mes.isopen = @"1";
        mes.isopen = [NSString stringWithFormat:@"1/%@",model.messageUId];
        RCMessage *oldMess = [[RCIMClient sharedRCIMClient] getMessageByUId:model.messageUId];
        [[RCIMClient sharedRCIMClient] setMessageExtra:oldMess.messageId value:mes.isopen];
        
        for (RCMessageModel *model in self.conversationDataRepository) {
            if (model.messageId == oldMess.messageId) {
                if (model.messageId == oldMess.messageId) {
                    XYreadoneContent *oldHongBao = (XYreadoneContent *)model.content;
                    oldHongBao.isopen = mes.isopen;
                    model.content = oldHongBao;
                }
            }
        }
        [self.conversationMessageCollectionView reloadData];
    }
}

/**
 礼物定时器release
 */
-(void)timeFireMethod{
    _second ++;
    if (_second >= 3) {
        [_flowFlower endFlyFlower];
        [_gifTimer invalidate];
        _flowFlower = nil;
        _gifTimer = nil;
    }
}


- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    if ([message.content isKindOfClass:[XYredMessageContent class]]) {
        
    }
}

- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model{

    if ([model.content isKindOfClass:[RCRichContentMessage class]]) {

        RCRichContentMessage *message = (RCRichContentMessage *)model.content;

        NSArray *array = [message.extra componentsSeparatedByString:@","];

        NSString *gidStr = [array[0] componentsSeparatedByString:@":"][1] ;

        NSString *gid = [gidStr substringWithRange:NSMakeRange(1, gidStr.length - 2)];

        NSString *state = [[array[1] componentsSeparatedByString:@":"][1] substringToIndex:1];

        AFHTTPSessionManager *manager = [LDAFManager sharedManager];

        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupinfo"];

        NSDictionary *parameters = @{@"gid":gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];

            if (integer != 2000) {

                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
            }else{

                if ([responseObject[@"data"][@"userpower"] intValue] < 1) {

                    if ([responseObject[@"data"][@"userpower"] intValue] == 0) {

                        LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];

                        ivc.gid = gid;

                        [self.navigationController pushViewController:ivc animated:YES];

                    }else if([responseObject[@"data"][@"userpower"] intValue] == -1){

                        LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];

                        ivc.state = state;

                        ivc.gid = gid;

                        [self.navigationController pushViewController:ivc animated:YES];

                    }

                }else{

                    LDGroupInformationViewController *fvc = [[LDGroupInformationViewController alloc] init];

                    fvc.gid = gid;

                    [self.navigationController pushViewController:fvc animated:YES];

                }

            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            NSLog(@"%@",error);
        }];

    }else{

        [super didTapUrlInMessageCell:url model:model];
    }

}

- (void)showChooseUserViewController:(void (^)(RCUserInfo *selectedUserInfo))selectedBlock
                              cancel:(void (^)(void))cancelBlock{
    LDGroupAtPersonViewController *atPerson = [[LDGroupAtPersonViewController alloc] init];
    atPerson.groupId = self.groupId;
    atPerson.block = ^(RCUserInfo *user) {
        selectedBlock(user);
    };
    [self.navigationController pushViewController:atPerson animated:YES];
}

-(void)getgroupinfo
{
    NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupinfo"];
    NSDictionary *parameters = @{@"gid":self.groupId,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
        
        self.infoModel = [[groupinfoModel alloc] init];
        self.infoModel = [groupinfoModel yy_modelWithJSON:responseObj];
        
        NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
        if (integer==2000) {
            
            //2 管理员 1  群主
            if ([responseObj[@"data"][@"userpower"] intValue] ==2||[responseObj[@"data"][@"userpower"] intValue] ==3)
            {
                self.isadmin = YES;
            }
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)createButton{
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"群组图标"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{

    if (!([self.infoModel.retcode intValue]==2000)) {
        NSString *msg = self.infoModel.msg;
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:msg];
    }
    else
    {
        if ([self.infoModel.data.userpower intValue]<1) {
            LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];
            ivc.gid = self.groupId;
            [self.navigationController pushViewController:ivc animated:YES];
        }
        else
        {
            LDGroupInformationViewController *fvc = [[LDGroupInformationViewController alloc] init];
            self.isadmin = YES;
            fvc.gid = self.groupId;
            fvc.chatStsate = @"yes";
            [self.navigationController pushViewController:fvc animated:YES];
        }
    }
}

//点击聊天头像查看个人信息
- (void)didTapCellPortrait:(NSString *)userId{
    //    NSLog(@"%@",userId);
    [self createData:userId];
}

-(void)createRefreshUserData:(NSString *)groupId{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    
    NSDictionary *parameters;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"gid":groupId,@"lat":[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]};
        
    }else{
        
        parameters = @{@"gid":groupId,@"lat":@"",@"lng":@""};
    }

    
    [manager POST:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Other/getGroupinfo"] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        //        NSLog(@"%@",responseObject);
        if (integer == 2000) {
            
            //此处为了演示写了一个用户信息
            RCGroup *group = [[RCGroup alloc]init];
            group.groupId = groupId;
            group.groupName = responseObject[@"data"][@"groupname"];
            group.portraitUri = responseObject[@"data"][@"group_pic"];
            [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:groupId];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"88888%@",error);
        
    }];

}


-(void)createData:(NSString *)userId{
    
    LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
    
    avc.userID = userId;
    
    [self.navigationController pushViewController:avc animated:YES];
}



#pragma mark - 发送及时消息

-(void)sendoneimage:(NSString *)urls
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"svip"] intValue]==1||[[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue]==1) {
        NSString *img = urls;
        NSDictionary *para = @{@"imageUrl":img,@"isopen":@"0"};
        XYreadoneContent *content = [XYreadoneContent messageWithDict:para];
        content.imageUrl = urls;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:0 error:0];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [self sendMessage:content pushContent:dataStr];
    }
    else
    {
        UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"该功能仅限VIP可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            [self.navigationController pushViewController:mvc animated:YES];
        }];
        [control addAction:action0];
        [control addAction:action1];
        [self presentViewController:control animated:YES completion:^{
            
        }];
    }
}


#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    //    imagePickerVc.cropRect = CGRectMake(0, (HEIGHT - WIDTH)/2, WIDTH, WIDTH);
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            return [self takePhoto];
            
        });
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {
        
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (/* DISABLES CODE */ (YES)) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            
                            imagePicker.allowCrop = YES;
                            imagePicker.needCircleCrop = NO;
                            //                            imagePicker.circleCropRadius = 100;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                            
                        } else {
                            
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    
    NSArray *photos = @[image];
    [self thumbnaiWithImage:photos andAssets:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self thumbnaiWithImage:photos andAssets:assets];
}
//上传图片
-(void)thumbnaiWithImage:(NSArray*)imageArray andAssets:(NSArray *)assets{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    [manager POST:[NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/Api/fileUpload"] parameters: nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(imageArray[0], 0.1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [responseObject objectForKey:@"data"];
        self.sendimgUrl = [PICHEADURL stringByAppendingString:str];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self sendoneimage:self.sendimgUrl];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
