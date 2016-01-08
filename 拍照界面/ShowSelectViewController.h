//
//  ShowSelectViewController.h
//  拍照界面
//
//  Created by zhouyantong on 15/7/23.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowSelectViewController : UIViewController
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSArray * urlArray;
- (id)initWithData:(NSArray *)data;

@end
