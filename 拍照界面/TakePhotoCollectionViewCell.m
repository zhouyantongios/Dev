//
//  TakePhotoCollectionViewCell.m
//  拍照界面
//
//  Created by zhouyantong on 15/7/20.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import "TakePhotoCollectionViewCell.h"

@implementation TakePhotoCollectionViewCell{
    UIView * view;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    view = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:view];
}
- (void)setTakeView:(UIView *)takeView{
    view = takeView;
}
@end
