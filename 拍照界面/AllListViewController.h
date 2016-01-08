//
//  AllListViewController.h
//  拍照界面
//
//  Created by zhouyantong on 15/7/22.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AllListViewController;
@protocol AllListViewDelegate <NSObject>

- (void)submitData:(NSArray *)data andFullImageData:(NSArray *)array;

@end

@interface AllListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

- (id)initWithDelegate:(id)delegate;
@property (nonatomic,weak)id<AllListViewDelegate>delegate;

@end
