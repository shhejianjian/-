//
//  XHComplainViewController.m
//  XHZF
//
//  Created by 谢琰 on 16/3/31.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHComplainViewController.h"
#import "XHVideoViewController.h"
#import "takePhoto.h"
#import "XHConst.h"
#import "BSHttpTool.h"
#import "SVProgressHUD.h"
#import "NSString+FontAwesome.h"
#import "IQKeyboardManager.h"
#import "AFNetWorking.h"
#import "XHAttachment.h"
#import "MJExtension.h"
#import "LeafProgressView.h"
@interface XHComplainViewController ()<UITextViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *previewLabel;
@property (weak, nonatomic) IBOutlet UITextView *instrumentTextView;
@property (weak, nonatomic) IBOutlet UIButton *vedioButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (nonatomic, strong) NSMutableArray *attachmentPhotos;
@property (nonatomic, strong) NSMutableArray *attachmentVedios;
@property (nonatomic, strong) NSMutableArray *attachments;

@end

@implementation XHComplainViewController
- (NSMutableArray *)attachmentPhotos
{
    if (!_attachmentPhotos) {
        _attachmentPhotos = [[NSMutableArray alloc]init];
    }
    return _attachmentPhotos;
}

- (NSMutableArray *)attachments
{
    if (!_attachments) {
        _attachments = [[NSMutableArray alloc]init];
    }
    return _attachments;
}
- (NSMutableArray *)attachmentVedios
{
    if (!_attachmentVedios) {
        _attachmentVedios = [[NSMutableArray alloc]init];
    }
    return _attachmentVedios;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
   }
- (void)setupUI
{
    self.phoneButton.layer.cornerRadius = 20.0f;
    self.vedioButton.layer.cornerRadius = 20.0f;
    self.phoneButton.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:35];
    [self.phoneButton setTitle:@"\uf28c" forState:UIControlStateNormal];
    [self.phoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.phoneButton.backgroundColor = XHPhoneColor;
    self.vedioButton.titleLabel.font = [UIFont fontWithName:@"Material-Design-Iconic-Font" size:40];
    [self.vedioButton setTitle:@"\uf2e0" forState:UIControlStateNormal];
    [self.vedioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.vedioButton.backgroundColor = XHVideoColor;
}
- (void)setupNav
{
    
   
    self.navigationItem.title = @"我要投诉";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.arrowLabel.font = [UIFont fontWithName:@"Ionicons" size:25];
    self.arrowLabel.text = @"\uf3d0";
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
- (void)cancle
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)finish
{
    if (self.instrumentTextView.text.length != 0) {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定下单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alertView show];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"请填写投诉说明"];
    }
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"description"] = self.instrumentTextView.text;
        if (self.attachmentPhotos.count > 0 || self.attachmentVedios.count > 0) {
            if (self.attachmentPhotos.count > 0) {
                for (NSString *filename in self.attachmentPhotos) {
                    XHAttachment *attach = [[XHAttachment alloc]init];
                    attach.type = @"Picture";
                    attach.filename = filename;
                    [self.attachments addObject:attach.mj_keyValues];
                }
            }
            if (self.attachmentVedios.count > 0) {
                for (NSString *filename in self.attachmentVedios) {
                    XHAttachment *attach = [[XHAttachment alloc]init];
                    attach.type = @"Vedio";
                    attach.filename = filename;
                    [self.attachments addObject:attach.mj_keyValues];
                }

            }
               params[@"attachmentList"] = self.attachments;
        }

        [BSHttpTool post:XHComplaintUrl  params:params success:^(id json) {
            XHLog(@"下单参数%@",params);
             [SVProgressHUD showSuccessWithStatus:@"下单成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"下单失败"];
         }];
        
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    XHLog(@"我要投诉%@",textView.text);
    if (textView.text.length != 0) {
        self.previewLabel.hidden = YES;
    }else{
        self.previewLabel.hidden = NO;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    

    //注册通知,监听键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(KeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(KeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
    
}
- (void)KeyboardDidShow:(NSNotification*)noti
{
    //获取键盘高度
    CGRect frame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.instrumentTextView.contentInset = UIEdgeInsetsMake(0, 0,frame.size.height - 100, 0);
}
- (void)KeyboardDidHidden
{
    self.instrumentTextView.contentInset = UIEdgeInsetsZero;
}
- (IBAction)btnTakePhoneClick:(id)sender {
    [takePhoto sharePicture:^(UIImage *image) {
        // 1.请求管理者
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,XHAttachmentUrl];
        
        // 2.发送请求
        [mgr POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            // 拼接文件数据
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            [formData appendPartWithFileData:data name:@"attachment" fileName:@"att.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            [self.attachmentPhotos addObject:responseObject[@"tempFilename"]];
            NSLog(@"上传成功%@",responseObject[@"tempFilename"]);
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"上传失败"];
        }];
        

    }];
}

- (IBAction)btnVedioClick:(id)sender {
    XHVideoViewController *videoVC = [[XHVideoViewController alloc]init];
    videoVC.returnFileNameBlock = ^(NSString *fileName){
        [self.attachmentVedios addObject:fileName];
    };
    [self.navigationController pushViewController:videoVC animated:YES];}

@end
