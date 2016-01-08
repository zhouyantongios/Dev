//
//  ViewController.m
//  拍照界面
//
//  Created by zhouyantong on 15/7/17.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import "ViewController.h"
#import "CustomPhotoView.h"
#import "CustomReadPhotoViewController.h"
#import "CustomTakePhotoViewController.h"
#import "AllListViewController.h"
#import <AVFoundation/AVFoundation.h>   //调用闪光灯的框架
@interface ViewController ()<CustomPhotoDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UIImagePickerController * imagePickerViewController;
@property (nonatomic,strong)CustomPhotoView * overlayView;
@property (nonatomic,strong)AVCaptureSession * avSession;
@property (nonatomic,strong)NSString * flash;
@property (nonatomic,strong)CustomReadPhotoViewController * customReadView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * takePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    takePhoto.frame = CGRectMake(100, 100, 40,40);
    takePhoto.backgroundColor = [UIColor redColor];
    [takePhoto addTarget:self action:@selector(showView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhoto];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    self.flash = [user objectForKey:@"Flash"];
}

- (void)showView{
    CustomReadPhotoViewController * custom = [[CustomReadPhotoViewController alloc]initWithDelegate:self];
    [self.navigationController pushViewController:custom animated:YES];
    
//    CustomTakePhotoViewController * custom = [[CustomTakePhotoViewController alloc]initWithPhotoFrame:CGRectMake(0, 0, 100, 100)];
//    custom.isSmall = YES;
//    [self.navigationController pushViewController:custom animated:YES];
    
//    ListViewController * listVC = [[ListViewController alloc]init];
//    [self.navigationController pushViewController:listVC animated:YES];
    
//    AllListViewController * listVC = [[AllListViewController alloc]init];
//    [self.navigationController pushViewController:listVC animated:YES];
}
- (void)showTakePhotoView{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerViewController = [[UIImagePickerController alloc]init];
        self.overlayView = [[CustomPhotoView alloc]initWithDelegate:self];
        self.imagePickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerViewController.delegate = self;
        //隐藏系统下方自带的工具栏
        self.imagePickerViewController.showsCameraControls = NO;
        
        self.imagePickerViewController.navigationBarHidden = YES;
        
        //设置拍照完或者选择完照片后,是否跳到编辑模式进行图片裁剪
        [self.imagePickerViewController setAllowsEditing:YES];
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        float aspectRatio = 4.0/3.0;
        float scale = screenSize.height/screenSize.width * aspectRatio;
        self.imagePickerViewController.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
        
        CGRect overlayFrame = self.imagePickerViewController.cameraOverlayView.frame;
        self.overlayView.frame = overlayFrame;
        
        //设置闪光等模式
        if ([self.flash isEqualToString:@"UIImagePickerControllerCameraFlashModeOn"]) {
            self.imagePickerViewController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        }else{
            self.imagePickerViewController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        }
            self.imagePickerViewController.cameraOverlayView = self.overlayView;
        }else{
            self.imagePickerViewController = [[UIImagePickerController alloc]init];
            self.imagePickerViewController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    [self presentViewController:self.imagePickerViewController animated:YES completion:nil];
}
#pragma mark - 
#pragma mrak - TakePhotoDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //获取图片的原图
    UIImage * img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
//    //获取图片的裁剪图
//    UIImage * edit = [info objectForKey:UIImagePickerControllerEditedImage];
//    
//    //获取图片裁剪后剩下的图
//    UIImage * crop = [info objectForKey:UIImagePickerControllerCropRect];
//    
//    //获取图片的url
//    NSURL * url = [info objectForKey:UIImagePickerControllerMediaURL];
//    
//    //获取图片的metadata数据信息
//    NSDictionary * metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
    
    
//    UIImage * img = nil;
//    if (self.imagePickerViewController.allowsEditing) {
//        img = [info objectForKey:UIImagePickerControllerEditedImage];
//    }else{
//        img = [info objectForKey:UIImagePickerControllerOriginalImage];
//    }
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(img, nil,nil, nil);
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark - ButtonDelegate
//闪光灯
- (void)tapFlashLamp:(UIButton *)sender{
    if (self.imagePickerViewController.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff) {
        self.imagePickerViewController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        self.flash = @"UIImagePickerControllerCameraFlashModeOn";
        NSLog(@"闪光灯打开");
    }else{
        self.imagePickerViewController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        self.flash = @"UIImagePickerControllerCameraFlashModeOff";
        NSLog(@"闪光灯关闭");
    }
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setObject:self.flash forKey:@"Flash"];
    [user synchronize];
}

//前后摄像头切换
- (void)exchange:(UIButton *)sender{
    if (self.imagePickerViewController.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        self.imagePickerViewController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }else{
        self.imagePickerViewController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}
//退出按钮
- (void)closeBtn:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//拍照按钮
- (void)takePhoto:(UIButton *)sender{
    [self.imagePickerViewController takePicture];
}
//查找相册按钮
- (void)readBtn:(UIButton *)sender{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [self presentViewController:_customReadView animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"访问图片库错误"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
    }
}
//选中图片进入的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
