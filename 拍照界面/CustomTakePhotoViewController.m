//
//  CustomTakePhotoViewController.m
//  拍照界面
//
//  Created by zhouyantong on 15/7/20.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import "CustomTakePhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EditPhotoViewController.h"
@interface CustomTakePhotoViewController (){
    UIImagePickerController * imagePickerController;
    CustomPhotoView * overlayView;
    NSString * flashLight;
    CGRect  photoFrame;
}

@end

@implementation CustomTakePhotoViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [imagePickerController removeFromParentViewController];
    [imagePickerController.view removeFromSuperview];
}

- (instancetype)initWithPhotoFrame:(CGRect )frame{
    self = [super init];
    if (self) {
        photoFrame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self takePhotoAnimate];
}
- (void)takePhotoAnimate{
    
    [self initTakePhotoView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isSmall) {
        [self.navigationController setNavigationBarHidden:NO];
    }else{
        [self.navigationController setNavigationBarHidden:YES];
    }
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    flashLight = [user objectForKey:@"Flash"];
}
- (void)initTakePhotoView{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController = [[UIImagePickerController alloc]init];
        overlayView = [[CustomPhotoView alloc]initWithDelegate:self];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        //隐藏系统下方自带的工具栏
        imagePickerController.showsCameraControls = NO;
        
        imagePickerController.navigationBarHidden = YES;
        
        //设置拍照完或者选择完照片后,是否跳到编辑模式进行图片裁剪
        [imagePickerController setAllowsEditing:YES];
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        float aspectRatio = 4.0/3.0;
        float scale = screenSize.height/screenSize.width * aspectRatio;
        imagePickerController.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
        
        CGRect overlayFrame = imagePickerController.cameraOverlayView.frame;
        overlayView.frame = overlayFrame;
        
        //设置闪光等模式
        if ([flashLight isEqualToString:@"UIImagePickerControllerCameraFlashModeOn"]) {
            imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        }else{
            imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        }
        if (self.isSmall == NO) {
            imagePickerController.cameraOverlayView = overlayView;
        }
    }else{
        imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    if (self.isSmall == YES) {
        imagePickerController.view.frame = photoFrame;
    }
    [self.view addSubview:imagePickerController.view];
}
#pragma mark -
#pragma mrak - TakePhotoDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [imagePickerController.view setHidden:YES];
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    EditPhotoViewController * editVC = [[EditPhotoViewController alloc]initWithPhoto:image];
    [self.view addSubview:editVC.view];
    [self addChildViewController:editVC];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - ButtonDelegate
//闪光灯
- (void)tapFlashLamp:(UIButton *)sender{
    if (imagePickerController.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff) {
        imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        flashLight = @"UIImagePickerControllerCameraFlashModeOn";
        NSLog(@"闪光灯打开");
    }else{
        imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        flashLight = @"UIImagePickerControllerCameraFlashModeOff";
        NSLog(@"闪光灯关闭");
    }
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setObject:flashLight forKey:@"Flash"];
    [user synchronize];
}

//前后摄像头切换
- (void)exchange:(UIButton *)sender{
    if (imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }else{
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}
//退出按钮
- (void)closeBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];

}
//拍照按钮
- (void)takePhoto:(UIButton *)sender{
    [imagePickerController takePicture];
}
//查找相册按钮
- (void)readBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//选中图片进入的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [self dismissViewControllerAnimated:YES completion:nil];
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
