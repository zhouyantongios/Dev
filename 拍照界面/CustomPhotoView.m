//
//  CustomPhotoView.m
//  拍照界面
//
//  Created by zhouyantong on 15/7/17.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import "CustomPhotoView.h"
#define info self.frame.size
@implementation CustomPhotoView

- (instancetype)initWithDelegate:(id<CustomPhotoDelegate>)delegate{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = delegate;
        [self initPhotoView];
    }
    return self;
}
- (void)initPhotoView{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, info.width, (info.height - info.width)/2)];
    headerView.backgroundColor = [UIColor blackColor];
    headerView.alpha = 0.5;
    [self addSubview:headerView];
    
    UIButton * flashLamp = [UIButton buttonWithType:UIButtonTypeCustom];
    flashLamp.frame = CGRectMake(10, 50, 40, 40);
    flashLamp.backgroundColor = [UIColor redColor];
    flashLamp.tag = 100+1;
    [flashLamp addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:flashLamp];
    
    UIButton * exchange = [UIButton buttonWithType:UIButtonTypeCustom];
    exchange.frame = CGRectMake(info.width - 50, 50, 40, 40);
    exchange.backgroundColor = [UIColor yellowColor];
    exchange.tag = 100+2;
    [exchange addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:exchange];
    
    
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height + info.width, info.width, headerView.frame.size.height)];
    footerView.backgroundColor = [UIColor blackColor];
    footerView.alpha = 0.5;
    [self addSubview:footerView];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(20, 50, 40, 40);
    closeBtn.backgroundColor = [UIColor blueColor];
    closeBtn.tag = 100+3;
    [closeBtn addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:closeBtn];
    
    
    UIButton * takePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    takePhoto.frame = CGRectMake((info.width - 100)/2, 50, 100, 100);
    takePhoto.backgroundColor = [UIColor purpleColor];
    takePhoto.tag = 100+4;
    [takePhoto addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:takePhoto];
    
    UIButton * readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    readBtn.frame = CGRectMake(info.width - 50, 50, 40, 40);
    readBtn.backgroundColor = [UIColor orangeColor];
    readBtn.tag = 100+5;
    [readBtn addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:readBtn];
}
- (void)tapView:(UIButton *)sender{
    if (sender.tag == 101) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tapFlashLamp:)]) {
            [self.delegate tapFlashLamp:sender];
        }
    } else if (sender.tag == 102){
        if (self.delegate && [self.delegate respondsToSelector:@selector(exchange:)]) {
            [self.delegate exchange:sender];
        }
        
    } else if (sender.tag == 103){
        if (self.delegate && [self.delegate respondsToSelector:@selector(closeBtn:)]) {
            [self.delegate closeBtn:sender];
        }
    } else if (sender.tag == 104){
        if (self.delegate && [self.delegate respondsToSelector:@selector(takePhoto:)]) {
            [self.delegate takePhoto:sender];
        }
    } else if (sender.tag == 105){
        if (self.delegate && [self.delegate respondsToSelector:@selector(readBtn:)]) {
            [self.delegate readBtn:sender];
        }
    }
}
@end
