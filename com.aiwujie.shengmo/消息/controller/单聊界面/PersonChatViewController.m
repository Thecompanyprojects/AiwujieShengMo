//
//  PersonChatViewController.m
//  yupaopao
//
//  Created by a on 16/8/14.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "PersonChatViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDLookOtherGroupInformationViewController.h"
#import "LDGroupInformationViewController.h"
#import "GifView.h"
#import "XYRichMessageCell.h"
#import "XYRichMessageContent.h"
#import "LDMyWalletPageViewController.h"
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
#import "imagebrowserVC.h"

@interface PersonChatViewController ()<RCPluginBoardViewDelegate,TZImagePickerControllerDelegate>
{
    CGRect viewRect;
}
@property (strong, nonatomic) UIView *upView;
//礼物界面
@property (nonatomic,strong) GifView *gif;
@property (nonatomic,copy) NSString *sendimgUrl;

@end

@implementation PersonChatViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

-(void)notifyUpdateUnreadMessageCount
{
    [super notifyUpdateUnreadMessageCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createButton];
    });
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //注册自定义消息Cell
    [self registerClass:[XYRichMessageCell class] forMessageClass:[XYRichMessageContent class]];
    [self registerClass:[XYreadoneCell classForKeyedArchiver] forMessageClass:[XYreadoneContent class]];
    
    if (_type != personIsNormal) {
        
        //更改导航栏的标题文字
        [self changeNavigationTitle];
    }

    if ([self.state intValue] == 2) {
        
        if (ISIPHONEX) {
            
            self.conversationMessageCollectionView.frame = CGRectMake(0, 144, WIDTH, HEIGHT - 144);
            
            _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 88, WIDTH, 56)];
            
        }else{
            
            self.conversationMessageCollectionView.frame = CGRectMake(0, 120, WIDTH, HEIGHT - 120);
            
            _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 56)];
        }
        
        _upView.backgroundColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
        
        [self.view addSubview:_upView];
        
        UILabel *showLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 209, 20)];
        showLabel1.text = @"对方已关注你，是否关注对方?";
        showLabel1.textColor = [UIColor whiteColor];
        showLabel1.font = [UIFont systemFontOfSize:15];
        [_upView addSubview:showLabel1];
        
        UILabel *showLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 29, 209, 20)];
        showLabel2.text = @"互相关注即为好友";
        showLabel2.textColor = [UIColor whiteColor];
        showLabel2.font = [UIFont systemFontOfSize:11];
        [_upView addSubview:showLabel2];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 35, 21, 1, 17)];
        lineView.backgroundColor = [UIColor whiteColor];
        [_upView addSubview:lineView];
        
        
        UIButton *attentButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 90, 17, 43, 23)];
        [attentButton setTitle:@"关注" forState:UIControlStateNormal];
        [attentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [attentButton addTarget:self action:@selector(attentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        attentButton.titleLabel.font = [UIFont systemFontOfSize:13];
        attentButton.layer.borderWidth = 1;
        attentButton.layer.borderColor = [UIColor whiteColor].CGColor;
        attentButton.layer.cornerRadius = 2;
        attentButton.clipsToBounds = YES;
        [_upView addSubview:attentButton];
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 30, 16, 25, 25)];
        [deleteButton setTitle:@"×" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:22];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_upView addSubview:deleteButton];
        
    }
    [self createButton];
    [self addredEnvelope];
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
    return messageCotent;
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    if ([message.content isKindOfClass:[XYreadoneContent class]]) {
        
    }
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view
{
    [super didLongTouchMessageCell:model inView:view];
//    view.userInteractionEnabled = true;
//    viewRect = view.bounds;
//    UILongPressGestureRecognizer * recognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEvent:)];
//    [view addGestureRecognizer:recognizer];
}

-(void)longPressEvent:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];//一定要写
        UIMenuController * menuController = [UIMenuController sharedMenuController];
        [menuController setTargetRect:viewRect inView:self.view];
        [menuController setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder{
    return true;
}

- (void)didTapMessageCell:(RCMessageModel *)model
{
    [super didTapMessageCell:model];
    if ([model.objectName isEqualToString:@"ec:messagereadone"]) {
        
        XYreadoneContent *content = (XYreadoneContent*)model.content;
        imagebrowserVC *vc = [imagebrowserVC new];
        vc.imageUrl = content.imageUrl;
        vc.returnBlock = ^{
            //监测到截图之后的操作
            RCInformationNotificationMessage *warningMsg = [RCInformationNotificationMessage notificationWithMessage:@"您进行了截图" extra:nil];
//            RCInformationNotificationMessage *warningMsg2 = [RCInformationNotificationMessage notificationWithMessage:@"对方进行了截图" extra:nil];
            BOOL saveToDB = YES; //是否保存到数据库中
            RCMessage *savedMsg;
//            RCMessage *sendMsg;
            if (saveToDB) {
                savedMsg = [[RCIMClient sharedRCIMClient] insertIncomingMessage:self.conversationType targetId:self.targetId senderUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId receivedStatus:(RCReceivedStatus)SentStatus_SENT content:warningMsg];
//                sendMsg = [[RCIMClient sharedRCIMClient] insertOutgoingMessage:sendMsg.conversationType targetId:self.targetId sentStatus:SentStatus_SENT  content:warningMsg2];
            } else {
                savedMsg =[[RCMessage alloc] initWithType:self.conversationType targetId:self.targetId direction:MessageDirection_SEND messageId:-1 content:warningMsg];
            }
//            [self appendAndDisplayMessage:sendMsg];
            [self appendAndDisplayMessage:savedMsg];
            
        };
        [self presentViewController:vc animated:NO completion:^{
            
        }];


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
 聊天页面发礼物
 */
-(void)addredEnvelope
{
    self.chatSessionInputBarControl.pluginBoardView.pluginBoardDelegate = self;
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"聊天-礼物"] title:@"礼物" atIndex:6 tag:2001];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"闪照"] title:@"闪照" atIndex:7 tag:2002];
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag
{
    
    if (tag==1101||tag==1102) {
        if (![self.state isEqualToString:@"3"]) {
            
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"您和对方还不是好友" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *acion0 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"加好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self attentButtonClick];
            }];
            [control addAction:acion0];
            [control addAction:action1];
            [self presentViewController:control animated:YES completion:^{

            }];
        }
        else
        {
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
        }
    }
    if (tag==1001||tag==1002||tag==1003) {
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
    if (tag==2001) {
        //礼物功能
        
        _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) andisMine:NO :^{
            LDMyWalletPageViewController *cvc = [[LDMyWalletPageViewController alloc] init];
            cvc.type = @"0";
            [self.navigationController pushViewController:cvc animated:YES];
            
        }];
        [_gif getPersonUid:self.mobile andSign:@"赠送给某人"andUIViewController:self];
        
        __weak typeof (self) weakSelf = self;
        
        _gif.sendmessageBlock = ^(NSDictionary *dic) {
            NSString *imagename = [dic objectForKey:@"image"];
 
            NSDictionary *para = @{@"number":dic[@"num"],@"imageName":imagename};
            XYRichMessageContent *addcontent = [XYRichMessageContent messageWithDict:para];
            addcontent.number = dic[@"num"];
            addcontent.imageName = dic[@"image"];
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para options:0 error:0];
            NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            [weakSelf sendMessage:addcontent pushContent:dataStr];
            
        };
        [self.tabBarController.view addSubview:_gif];

    }
    if (tag==2002) {
        //阅后即焚
        self.sendimgUrl = [NSString new];
        TZImagePickerController *imagePC=[[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];
        [imagePC setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
            
            
            
        }];
        [self presentViewController:imagePC animated:YES completion:^{
            
        }];
    }
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

/**
  * 更改导航栏的标题文字
 */
-(void)changeNavigationTitle{
    
    UIColor *navTitleColor = [[UIColor alloc] init];
    UIImage *navTitleImage = [[UIImage alloc] init];
    
    if (_type == personIsADMIN) {
        
        navTitleColor = [UIColor blackColor];
        navTitleImage = [UIImage imageNamed:@"官方认证"];
        
    }else if(_type == personIsVOLUNTEER) {
        
        navTitleColor = [UIColor greenColor];
        navTitleImage = [UIImage imageNamed:@"志愿者标识"];
        
    }else if (_type == personIsSVIPANNUAL) {
        
        navTitleColor = [UIColor redColor];
        navTitleImage = [UIImage imageNamed:@"年svip标识"];
        
    }else if (_type == personIsSVIP) {
        
        navTitleColor = [UIColor redColor];
        navTitleImage = [UIImage imageNamed:@"svip标识"];
        
    }else if (_type == personIsVIPANNUAL) {
        
        navTitleColor = MainColor;
        navTitleImage = [UIImage imageNamed:@"年费会员"];
        
    }else if (_type == personIsVIP) {
        
        navTitleColor = MainColor;
        navTitleImage = [UIImage imageNamed:@"高级紫"];
    }
    
    UILabel *textLabel = [[UILabel alloc] init];
    
    // 创建一个富文本
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",self.title]];
    // 修改富文本中的不同文字的样式
    [attri addAttribute:NSForegroundColorAttributeName value:navTitleColor range:NSMakeRange(0, attri.length)];
    
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = navTitleImage;
    // 设置图片大小
    attch.bounds = CGRectMake(0, -3, 18, 18);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    
    // 用label的attributedText属性来使用富文本
    textLabel.attributedText = attri;
    
    [textLabel sizeToFit];
    
    textLabel.frame = CGRectMake(0, 0, CGRectGetWidth(textLabel.frame), CGRectGetHeight(textLabel.frame));
    
    self.navigationItem.titleView = textLabel;
}

- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model{
    
    if ([model.content isKindOfClass:[RCRichContentMessage class]]) {
        
        RCRichContentMessage *message = (RCRichContentMessage *)model.content;
        NSArray *array = [message.extra componentsSeparatedByString:@","];
        NSString *gidStr = [array[0] componentsSeparatedByString:@":"][1] ;
        NSString *gid = [gidStr substringWithRange:NSMakeRange(1, gidStr.length - 2)];
        NSString *state = [[array[1] componentsSeparatedByString:@":"][1] substringToIndex:1];
        NSString *url = [NSString stringWithFormat:@"%@%@",PICHEADURL,@"Api/friend/getGroupinfo"];
        NSDictionary *parameters;
        parameters = @{@"gid":gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        [NetManager afPostRequest:url parms:parameters finished:^(id responseObj) {
            NSInteger integer = [[responseObj objectForKey:@"retcode"] intValue];
            if (integer != 2000) {
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObj objectForKey:@"msg"]];
            }else{
                if ([responseObj[@"data"][@"userpower"] intValue] < 1) {
                    if ([responseObj[@"data"][@"userpower"] intValue] == 0) {
                        LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];
                        ivc.gid = gid;
                        [self.navigationController pushViewController:ivc animated:YES];
                    }else if([responseObj[@"data"][@"userpower"] intValue] == -1){
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
        } failed:^(NSString *errorMsg) {
            
        }];
        
     
    }else{
        
        [super didTapUrlInMessageCell:url model:model];
    }
}

//关注成为好友
-(void)attentButtonClick{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.mobile};
    [NetManager afPostRequest:[PICHEADURL stringByAppendingString:setfollowOne] parms:parameters finished:^(id responseObj) {
        NSInteger integer = [[responseObj objectForKey:@"retcode"] integerValue];
        if (integer != 2000) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            NSString *msg = [responseObj objectForKey:@"msg"];
            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"开会员" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                [self.navigationController pushViewController:mvc animated:YES];
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                cvc.where = @"8";
                [self.navigationController pushViewController:cvc animated:YES];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [control addAction:action1];
            [control addAction:action0];
            [control addAction:action2];
            [self presentViewController:control animated:YES completion:^{
                
            }];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self deleteButtonClick];
        }
    } failed:^(NSString *errorMsg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//删除上方view
-(void)deleteButtonClick{
    if (ISIPHONEX) {
        self.conversationMessageCollectionView.frame = CGRectMake(0, 88, WIDTH, HEIGHT - 172);
    }else{
        self.conversationMessageCollectionView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 114);
    }
    [_upView removeFromSuperview];
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell

                   atIndexPath:(NSIndexPath *)indexPath{

    RCMessageCell *messageCell = (RCMessageCell *)cell;
    
    if ([messageCell respondsToSelector:@selector(messageHasReadStatusView)]) {
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"已读"]];
        
        img.frame = CGRectMake(-2, 2, 17, 10);
        
        [messageCell.messageHasReadStatusView addSubview:img];
    }
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"个人图标"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
    LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
    avc.userID = self.mobile;
    [self.navigationController pushViewController:avc animated:YES];
}

//点击聊天头像查看个人信息

- (void)didTapCellPortrait:(NSString *)userId{
    
    [self createData:userId];
    
}


-(void)createData:(NSString *)userId{
    
    LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
    avc.userID = userId;
    [self.navigationController pushViewController:avc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
