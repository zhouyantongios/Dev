//
//  CustomReadPhotoViewController.m
//  拍照界面
//
//  Created by zhouyantong on 15/7/20.
//  Copyright (c) 2015年 zhouyantong. All rights reserved.
//

#import "CustomReadPhotoViewController.h"
#import "CustomReadPhotoCell.h"
#import "TakePhotoCollectionViewCell.h"
//#import <AssetsLibrary/AssetsLibrary.h>
#import "AllListViewController.h"
#import "CustomTakePhotoViewController.h"
#import "ShowSelectViewController.h"
#import "ALAssetsLibrary+Women.h"
@interface CustomReadPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AllListViewDelegate,CustomReadPhotoDelegate>{
    BOOL isHaveCamera;
    CustomTakePhotoViewController * customTakeVC;
    BOOL isBack;
    AllListViewController * listVC;
    NSMutableArray * selectArray;
    NSArray * reversePhoto;
}

@end

@implementation CustomReadPhotoViewController

- (id)initWithDelegate:(id<CustomReadPhotoViewDelegate>)delegate{
    self = [super init];
    if (self) {
        [self initNaviItem];
        self.delegate = delegate;
        self.dataArray = [[NSMutableArray alloc]init];
        selectArray = [[NSMutableArray alloc]init];
        self.saveResult = [[NSMutableArray alloc]init];
        self.originalPhotos = [[NSMutableArray alloc]init];
        isBack = NO;
    }
    return self;
}
- (void)initNaviItem{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =  CGRectMake(0, 0, 40, 40);
    [btn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    self.navigationItem.titleView = btn;
    
    UIBarButtonItem * sureBarItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(sure)];
    self.navigationItem.rightBarButtonItem = sureBarItem;
}
- (void)tap{
    listVC = [[AllListViewController alloc]initWithDelegate:self];
    [[UIApplication sharedApplication].keyWindow addSubview:listVC.view];
    [self addChildViewController:listVC];
}
- (void)sure{
    ShowSelectViewController * show = [[ShowSelectViewController alloc]initWithData:selectArray];
    isBack = YES;
    show.dataArray = [NSMutableArray arrayWithArray:reversePhoto];
    show.urlArray = [[self.saveResult reverseObjectEnumerator]allObjects];
    [self.navigationController pushViewController:show animated:YES];
    NSLog(@"%lu",(unsigned long)selectArray.count);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isBack) {
        [selectArray removeAllObjects];
        if (isHaveCamera) {
            [self addChildViewController:customTakeVC];
            [self.collectionView reloadData];
        }else{
            [self.collectionView reloadData];
        }
    }else {
        [self.collectionView reloadData];
    }
    if (self.dataArray == nil && isHaveCamera) {
        [self initWithRead];
    }
}
- (void)initWithRead{
    NSString *tipTextWhenNoPhotosAuthorization; // 提示语
    // 获取当前应用对照片的访问授权状态
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
        tipTextWhenNoPhotosAuthorization = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
        // 展示提示语
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
        @autoreleasepool {
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){

            NSLog(@"error occour =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location != NSNotFound){
                NSLog(@"无法访问相册,请在'设置->定位服务'设置为打开状态");
            }else{
                NSLog(@"相册访问失败");
            }
        };
         __weak  CustomReadPhotoViewController * this = self;
         __block UIImage *img = nil;
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index,BOOL *stop){
            if (result!=NULL) {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    img=[UIImage imageWithCGImage:result.thumbnail];
                    [this.dataArray addObject:img];
                    [this.saveResult addObject:result.defaultRepresentation.url];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                    });
                }
            }
        };
        ALAssetsLibraryGroupsEnumerationResultsBlock

        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){

            if (group == nil) {
                return;
            }
            if (group!=nil) {
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
        };
        ALAssetsLibrary* library = [ALAssetsLibrary defaultAssetsLibrary];
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
         
                               usingBlock:libraryGroupsEnumeration

                             failureBlock:failureblock];
        }
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithRead];
    isHaveCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    [self initCollectionView];
}
- (void)initCollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[CustomReadPhotoCell class] forCellWithReuseIdentifier:@"resign"];
    if (isHaveCamera) {
        [_collectionView registerClass:[TakePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"take"];
    }
    [self.view addSubview:_collectionView];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return isHaveCamera? _dataArray.count + 1 : _dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(80, 80);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    //如果存在相机,那么留出第一个cell的位置
    CustomReadPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"resign" forIndexPath:indexPath];
    cell.delegate = self;
    reversePhoto = [[_dataArray reverseObjectEnumerator]allObjects];
    if (isHaveCamera) {
        TakePhotoCollectionViewCell * cells;
        cells = [collectionView dequeueReusableCellWithReuseIdentifier:@"take" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            customTakeVC= [[CustomTakePhotoViewController alloc]initWithPhotoFrame:
                                                  CGRectMake(0, 0, cells.frame.size.width, cells.frame.size.height)];
            customTakeVC.isSmall = YES;
            [cells addSubview:customTakeVC.view];
            [self addChildViewController:customTakeVC];
            return cells;
        } else if (indexPath.row > 0){
            cell.img = [reversePhoto objectAtIndex:indexPath.row - 1];
            if ([selectArray containsObject:@(indexPath.row)]){
                cell.hasMaskView.hidden = NO;
            } else {
                cell.hasMaskView.hidden = YES;
            }
            return cell;
        }
    } else {
            cell.img = [reversePhoto objectAtIndex:indexPath.row];
            if ([selectArray containsObject:@(indexPath.row)]) {
                cell.hasMaskView.hidden = NO;
            } else {
                cell.hasMaskView.hidden = YES;
            }
            return cell;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomReadPhotoCell * cell;
    isBack = YES;
    if (isHaveCamera){
        if (indexPath.row == 0) {
            CustomTakePhotoViewController * custom = [[CustomTakePhotoViewController alloc]init];
            custom.isSmall = NO;
            [customTakeVC removeFromParentViewController];
            [self.navigationController pushViewController:custom animated:YES];
        } else if (indexPath.row > 0){
            cell = (CustomReadPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            cell.hasMaskView.hidden = !cell.hasMaskView.hidden;
            
            if (![selectArray containsObject:@(indexPath.row - 1)])
            {
                if (selectArray.count <4) {
                    [selectArray addObject:@(indexPath.row - 1)];
                }else{
                    cell.hasMaskView.hidden = YES;
                    [selectArray removeObject:@(indexPath.row - 1)];
                }
            }else{
                [selectArray removeObject:@(indexPath.row - 1)];
            }
        }
    }else{
        cell = (CustomReadPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.hasMaskView.hidden = !cell.hasMaskView.hidden;
        
        if (![selectArray containsObject:@(indexPath.row)]) {
            if (selectArray.count <4) {
                [selectArray addObject:@(indexPath.row)];
            }else{
                cell.hasMaskView.hidden = YES;
                [selectArray removeObject:@(indexPath.row)];
            }
        }else{
            [selectArray removeObject:@(indexPath.row)];
        }
    }
}

#pragma ALListViewDelegate
- (void)submitData:(NSArray *)data andFullImageData:(NSArray *)array{
    //移除数据,将获取到的新数据添加到数据中
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:data];
    [_saveResult removeAllObjects];
    [_saveResult addObjectsFromArray:array];
    [selectArray removeAllObjects];
    [listVC.view setHidden:YES];
    [self.collectionView reloadData];
}

#pragma mark-
#pragma mark--
- (void)returnSelectPhotos:(NSMutableArray *)photos{
    NSLog(@"%lu",(unsigned long)photos.count);
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
