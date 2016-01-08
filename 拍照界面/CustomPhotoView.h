//
//  CustomPhotoView.h
//  拍照界面
//
//  Created by zhouyantong on 15/7/17.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomPhotoView;

@protocol CustomPhotoDelegate <NSObject>
@required;

- (void)tapFlashLamp:(UIButton *)sender;

- (void)exchange:(UIButton *)sender;

- (void)closeBtn:(UIButton *)sender;

- (void)takePhoto:(UIButton *)sender;

- (void)readBtn:(UIButton *)sender;

@end

@interface CustomPhotoView : UIView

@property (nonatomic,weak)id<CustomPhotoDelegate>delegate;

- (instancetype)initWithDelegate:(id)delegate;

@end
