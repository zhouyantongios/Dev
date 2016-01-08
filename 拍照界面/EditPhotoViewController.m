//
//  EditPhotoViewController.m
//  拍照界面
//
//  Created by zhouyantong on 15/7/30.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import "EditPhotoViewController.h"

@interface EditPhotoViewController (){
    UIImage * editImage;
}

@end

@implementation EditPhotoViewController

- (id)initWithPhoto:(UIImage *)image{
    self = [super init];
    if (self) {
        editImage = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    headerView.backgroundColor = [UIColor blackColor];
    headerView.alpha = 0.5;
    [self.view addSubview:headerView];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80 - 80)];
    imageView.image = editImage;
    [self.view addSubview:imageView];
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height  - 80, self.view.frame.size.width, 80)];
    footerView.backgroundColor = [UIColor blackColor];
    footerView.alpha = 0.5;
    [self.view addSubview:footerView];
    
    UIButton * backBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 10, 40, 40);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:backBtn];
    
    UIButton * useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    useBtn.frame = CGRectMake(self.view.frame.size.width - 80 - 10, 10, 80, 40);
    [useBtn setTitle:@"使用照片" forState:UIControlStateNormal];
    [useBtn addTarget:self action:@selector(use) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:useBtn];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)use{
    [self.navigationController popViewControllerAnimated:YES];
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
