//
//  AllListViewController.m
//  拍照界面
//
//  Created by zhouyantong on 15/7/22.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import "AllListViewController.h"
#import "AllListViewCell.h"
#import "ALAssetsLibrary+Women.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface AllListViewController (){
    UITableView * _tableView;
    NSMutableArray * groupArray;
    NSMutableArray * photoArray;
    NSMutableArray * nameArray;
    NSMutableArray * numArray;
    NSMutableArray * showPhotoArray;
    NSMutableArray * originalPhotos;
    ALAssetsGroup * _group;
}
@end

@implementation AllListViewController

- (id)init{
    self = [super init];
    if (self) {
        groupArray = [[NSMutableArray alloc]init];
        photoArray = [[NSMutableArray alloc]init];
        nameArray = [[NSMutableArray alloc]init];
        numArray = [[NSMutableArray alloc]init];
        showPhotoArray = [[NSMutableArray alloc]init];
        originalPhotos = [[NSMutableArray alloc]init];
        _group = [[ALAssetsGroup alloc]init];
    }
    return self;
}
- (id)initWithDelegate:(id)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        groupArray = [[NSMutableArray alloc]init];
        photoArray = [[NSMutableArray alloc]init];
        nameArray = [[NSMutableArray alloc]init];
        numArray = [[NSMutableArray alloc]init];
        showPhotoArray = [[NSMutableArray alloc]init];
        originalPhotos = [[NSMutableArray alloc]init];
        _group = [[ALAssetsGroup alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllInformation];
    [self initTableView];
}

- (void)getAllInformation{
    @autoreleasepool {
        ALAssetsLibrary *assetsLibrary;
        __weak  NSMutableArray *groups = groupArray;
        __weak  NSMutableArray *groupImage = photoArray;
        __weak  NSMutableArray *groupName = nameArray;
        __weak  NSMutableArray *groupNum = numArray;
        assetsLibrary = [ALAssetsLibrary defaultAssetsLibrary];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [groups addObject:group];
                
                UIImage * image = [UIImage imageWithCGImage:[group posterImage]];
                [groupImage addObject:image];
                
                [groupName addObject:[group valueForProperty:ALAssetsGroupPropertyName]];
                
                NSString * num = [NSString stringWithFormat:@"%ld",(long)[group numberOfAssets]];
                [groupNum addObject:num];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        } failureBlock:^(NSError *error) {
            NSLog(@"Group not found!\n");
        }];
    }
}
- (void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,300) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nameArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * reversePhoto = [[photoArray reverseObjectEnumerator]allObjects];
    NSArray * reverseName = [[nameArray reverseObjectEnumerator]allObjects];
    NSArray * reverseCount = [[numArray reverseObjectEnumerator]allObjects];
    AllListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"resign"];
    if (cell == nil) {
        cell = [[AllListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resign"];
    }
    cell.headerView = [reversePhoto objectAtIndex:indexPath.row];
    cell.userName = [reverseName objectAtIndex:indexPath.row];
    cell.count = [reverseCount objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * group =[[groupArray reverseObjectEnumerator]allObjects];
    _group = [group objectAtIndex:indexPath.row];
    NSArray * array = [self getData:_group];
    if (self.delegate && [self.delegate respondsToSelector:@selector(submitData:andFullImageData:)]) {
        [self.delegate submitData:array andFullImageData:originalPhotos];
    }
}
- (NSArray *)getData:(ALAssetsGroup *)group{
    __weak NSMutableArray * exchangePhoto = showPhotoArray;
    __weak NSMutableArray * originalArray = originalPhotos;
    __block UIImage * eximage ;
        [_group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                eximage = [UIImage imageWithCGImage:result.thumbnail];
                [exchangePhoto addObject:eximage];
                [originalArray addObject:result.defaultRepresentation.url];
            }
        }];
    return exchangePhoto;
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
