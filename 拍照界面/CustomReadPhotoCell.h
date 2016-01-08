//
//  CustomReadPhotoCell.h
//  拍照界面
//
//  Created by zhouyantong on 15/7/20.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomReadPhotoCell;
@protocol CustomReadPhotoDelegate <NSObject>

- (void)returnSelectPhotos:(NSMutableArray *)photos;

@end

@interface CustomReadPhotoCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)UIImage * img;
@property (nonatomic,strong)UIImageView * hasMaskView;
@property (nonatomic,weak)id<CustomReadPhotoDelegate>delegate;
@end
