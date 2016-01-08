//
//  CustomReadPhotoViewController.h
//  拍照界面
//
//  Created by zhouyantong on 15/7/20.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomReadPhotoViewController;
@protocol CustomReadPhotoViewDelegate <NSObject>

- (void)customReadViewController:(CustomReadPhotoViewController *)assetsVC disFinishPickingAssets:(NSArray *)assets;

- (void)customReadViewController:(CustomReadPhotoViewController *)albumsVC failedWithError:(NSError *)error;

@end

@interface CustomReadPhotoViewController : UIViewController

@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)UIBarButtonItem * selectButton;
@property (nonatomic,weak)id<CustomReadPhotoViewDelegate>delegate;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * originalPhotos;
@property (nonatomic,strong)NSMutableArray * saveResult;
- (id)initWithDelegate:(id)delegate;

@end
