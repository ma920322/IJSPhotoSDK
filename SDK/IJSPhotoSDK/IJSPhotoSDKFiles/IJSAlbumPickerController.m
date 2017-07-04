//
//  IJSAlbumPickerController.m
//  JSPhotoSDK
//
//  Created by shan on 2017/5/29.
//  Copyright © 2017年 shan. All rights reserved.
//

#import "IJSAlbumPickerController.h"
#import "IJSAlbumPickerCell.h"
#import "IJSImageManager.h"
#import "IJSPhotoPickerController.h"
#import "NSBundle+IJSPhotoBundle.h"
#import "IJSConst.h"
#import "IJSImagePickerController.h"
#import "IJSPhotoPreviewController.h"
#import <IJSFoundation/IJSFoundation.h>
#import "IJSExtension.h"
static NSString * const cellID = @"cellID";
@interface IJSAlbumPickerController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

/* 照片列表参数 */
@property(nonatomic,strong) NSArray *albumListArr;

/* tableview */
@property(nonatomic,weak) UITableView *tableView;

@end

@implementation IJSAlbumPickerController

-(NSArray *)albumListArr
{
    if (!_albumListArr)
    {
        _albumListArr =[NSArray array];
    }
    return _albumListArr;
}

/*-----------------------------------系统方法-------------------------------------------------------*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self _createrNavigationUI];
    [self _configImageData];    // 获取数据
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self _configImageData];    // 获取数据
}

/*-----------------------------------自己的方法实现-------------------------------------------------------*/
#pragma mark 私有方法
// 导航条的文字和标题
-(void)_createrNavigationUI
{
    self.title  = [NSBundle localizedStringForKey:@"Photos"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:[NSBundle localizedStringForKey:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancleAndDisMiss)];
    
    UIButton *leftButton =[UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setImage:[IJSFImageGet loadImageWithBundle:@"JSPhotoSDK" subFile:nil grandson:nil imageName:@"jiahao" imageType:@"png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(addAppAlbum:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
}

-(void) _createTableViewUI
{
   UITableView *tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.rowHeight = albumCellHright;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[IJSAlbumPickerCell class] forCellReuseIdentifier:cellID];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView = tableView;
}
#pragma mark Tableview 代理方法
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumListArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IJSAlbumPickerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.models = self.albumListArr[indexPath.row];
    cell.selectionStyle = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IJSPhotoPickerController *vc =[[IJSPhotoPickerController alloc]init];
    vc.columnNumber = self.columnNumber;           // 传递列数计算展示图的大小
    IJSAlbumModel *model = self.albumListArr[indexPath.row];
    vc.albumModel = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
// 添加编辑模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
//左滑动出现的文字
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewRowAction *cancle = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:[NSBundle localizedStringForKey:@"Cancel"] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        
//        // 收回左滑出现的按钮(退出编辑模式)
//        tableView.editing = NO;
//    }];
//    cancle.backgroundColor =[UIColor blueColor];
//    
//    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[NSBundle localizedStringForKey:@"Delete"] handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        if (iOS8Later)
//        {
//            IJSAlbumModel *model = self.albumListArr[indexPath.row];
//            [[IJSImageManager shareManager]deleteAlbum:model.name completion:^(id assetCollection, NSError *error, BOOL isExistedOrIsSuccess) {
//                if (!error)
//                {
//                     [(IJSImagePickerController *)self.navigationController showAlertWithTitle:@"功能搁置"];
//                }else{
//                     [(IJSImagePickerController *)self.navigationController showAlertWithTitle:@"功能搁置"];
//                }
//            }];
//        }else{
//        
//        }
//        tableView.editing = NO;
//    }];
    return nil;
//    return @[cancle, delete];
}
//删除所做的动作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从数据源中删除
//    [_data removeObjectAtIndex:indexPath.row];
    // 从列表中删除
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark 获取相册列表
-(void)_configImageData
{
    __weak typeof (self) weakSelf = self;
    [[IJSImageManager shareManager]getAllAlbumsContentImage:YES contentVideo:YES completion:^(NSArray<IJSAlbumModel *> *models) {
        weakSelf.albumListArr = models;
        if (!self.tableView)
        {
           [self _createTableViewUI];
        }
        [_tableView reloadData];
    }];
}


#pragma mark 点击方法
-(void) cancleAndDisMiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) addAppAlbum:(UIButton *)button
{
    [button addSpringAnimation];
    [self addAlertTextField];
}

// 警告
-(void)addAlertTextField
{

    if (![[IJSImageManager shareManager]authorizationStatusAuthorized])
    {
        [(IJSImagePickerController *)self.navigationController showAlertWithTitle:@"您没有授权访问相册的权限,请您点击设置"];
        return;
    }
    if (iOS8Later)
    {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:[NSBundle localizedStringForKey:@"AlbumAlert"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof (alert) weakAlert = alert;
        UIAlertAction *cancleAction =[UIAlertAction actionWithTitle:[NSBundle localizedStringForKey:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        UIAlertAction *determineAction =[UIAlertAction actionWithTitle:[NSBundle localizedStringForKey:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
            
            [[IJSImageManager shareManager] createdAlbumName:weakAlert.textFields.firstObject.text completion:^(id assetCollection, NSError *error,BOOL isExisted) {
                if (error)
                {
                     [(IJSImagePickerController *)self.navigationController showAlertWithTitle:@"您创建的相册已经存在,或者系统原因没有创建成功"];
                }else{
                    [(IJSImagePickerController *)self.navigationController showAlertWithTitle:@"创建成功,保存图片到自定义相册可以进行浏览"];
                }
            }];
        }];
        [alert addAction:cancleAction];
        [alert addAction:determineAction];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        }];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:[NSBundle localizedStringForKey:@"AlbumAlert"] message:nil delegate:self cancelButtonTitle:[NSBundle localizedStringForKey:@"Cancel"]  otherButtonTitles:[NSBundle localizedStringForKey:@"OK"] , nil];
        alert.alertViewStyle =UIAlertViewStylePlainTextInput;//给提示窗口加上输入框
        [alert show];   //调用方法
    }
}

#pragma mark alert delegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];  //范围是 0 和1

    [[IJSImageManager shareManager] createdAlbumName:textField.text completion:^(id assetCollection, NSError *error,BOOL isExisted) {
        if (error)
        {
            [(IJSImagePickerController *)self.navigationController showAlertWithTitle:@"您创建的相册已经存在,或者系统原因没有创建成功"];
        }else{
            [(IJSImagePickerController *)self.navigationController showAlertWithTitle:@"创建成功,保存图片到自定义相册可以进行浏览"];
        }
    }];
};




@end
