//
//  ALAssetsLibrary+Women.m
//  拍照界面
//
//  Created by zhouyantong on 15/7/22.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import "ALAssetsLibrary+Women.h"

@implementation ALAssetsLibrary (Women)
+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
