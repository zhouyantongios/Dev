//
//  CustomReadPhotoCell.m
//  拍照界面
//
//  Created by zhouyantong on 15/7/20.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import "CustomReadPhotoCell.h"
@implementation CustomReadPhotoCell{
    NSMutableArray * allPhotos;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{

    self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:self.imageView];
    
    self.hasMaskView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Overlay"]];
    self.hasMaskView.frame = self.imageView.frame;
    self.hasMaskView.tag = 100;
    [self.hasMaskView setHidden:YES];
    [_imageView addSubview:self.hasMaskView];
    
}
- (void)setImg:(UIImage *)img{
    _imageView.image = img;
}



@end
