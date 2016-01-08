//
//  ShowSelectViewController.m
//  拍照界面
//
//  Created by zhouyantong on 15/7/23.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import "ShowSelectViewController.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+Women.h"
@interface ShowSelectViewController (){
    NSMutableArray * photos;
    NSMutableArray * getMarkArray;
    NSArray * array;
}

@end

@implementation ShowSelectViewController

- (id)initWithData:(NSMutableArray *)data{
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc]init];
        self.urlArray = [[NSMutableArray alloc]init];
        getMarkArray = [[NSMutableArray alloc]init];
        array = [[NSArray alloc]init];
        photos = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 100, 50, 50);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(tapShow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    if (photos.count > 0){
    array = [photos sortedArrayUsingSelector:@selector(compare:)];

    UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    image1.image = [self.dataArray objectAtIndex:[[array objectAtIndex:0] floatValue]];
    [self.view addSubview:image1];
    
    UIImageView * image2 = [[UIImageView alloc]initWithFrame:CGRectMake(100, 170, 50, 50)];
    image2.image = [self.dataArray objectAtIndex:[[array objectAtIndex:1] floatValue]];
    [self.view addSubview:image2];

    UIImageView * image3 = [[UIImageView alloc]initWithFrame:CGRectMake(100, 250, 50, 50)];
    image3.image = [self.dataArray objectAtIndex:[[array objectAtIndex:2] floatValue]];
    [self.view addSubview:image3];

    
    UIImageView * image4 = [[UIImageView alloc]initWithFrame:CGRectMake(100, 330, 50, 50)];
    image4.image = [self.dataArray objectAtIndex:[[array objectAtIndex:3] floatValue]];
    [self.view addSubview:image4];
    }
}
- (void)tapShow{
    ALAssetsLibrary *assetLibrary=[ALAssetsLibrary defaultAssetsLibrary];
    if (array.count == 0){
        return ;
    }
    [assetLibrary assetForURL:[self.urlArray objectAtIndex:[[array objectAtIndex:0] floatValue]]
                  resultBlock:^(ALAsset *asset)
     {
         [self printALAssetInfo:asset];
     }
                 failureBlock:^(NSError *error)
     {
         NSLog(@"error=%@",error);
     }];
}
- (void)printALAssetInfo:(ALAsset*)asset
{
    UIImage* photo = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:photo];
    NSLog(@"%@",NSStringFromCGSize(photo.size));
    imageView.image = photo;
    [self.view addSubview:imageView];
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
