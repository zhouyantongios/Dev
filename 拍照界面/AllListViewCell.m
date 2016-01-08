//
//  AllListViewCell.m
//  拍照界面
//
//  Created by zhouyantong on 15/7/22.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import "AllListViewCell.h"

@implementation AllListViewCell{
    UIImageView * photo;
    UILabel * name;
    UILabel * num;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    photo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    photo.backgroundColor = [UIColor redColor];
    [self addSubview:photo];
    
    name = [[UILabel alloc]initWithFrame:CGRectZero];
    name.backgroundColor = [UIColor yellowColor];
    [self addSubview:name];
    
    num = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:num];
}

- (void)setHeaderView:(UIImage *)headerView{
    photo.image = headerView;
}
- (void)setUserName:(NSString *)userName{
    name.text = userName;
    [name sizeToFit];
    name.frame = CGRectMake(photo.frame.origin.x + photo.frame.size.width + 10, 20, name.frame.size.width, name.frame.size.height);
}
- (void)setCount:(NSString *)count{
    num.text = count;
    [num sizeToFit];
    num.frame = CGRectMake(name.frame.origin.x + name.frame.size.width + 10, 20, num.frame.size.width, num.frame.size.height);
}
@end
