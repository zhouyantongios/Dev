//
//  CustomTakePhotoViewController.h
//  拍照界面
//
//  Created by zhouyantong on 15/7/20.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPhotoView.h"
@interface CustomTakePhotoViewController : UIViewController<CustomPhotoDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

- (instancetype)initWithPhotoFrame:(CGRect )frame;
@property (nonatomic,assign)BOOL isSmall;

@end
