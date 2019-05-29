//
//  ViewController.m
//  PDF-READDemo
//
//  Created by zhangxiaoye on 2019/5/28.
//  Copyright © 2019 zhangxiaoye. All rights reserved.
//

#import "ViewController.h"
#import <PDFReadViewController.h>
#import <Masonry.h>
#import <QuickLook/QuickLook.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc]init];
    
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [button setTitle:@"跳转" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(self.view);
        make.height.with.mas_equalTo(40);
    }];
    
}

- (void)BtnClick:(UIButton *)sender{
    
    PDFReadViewController *vc = [[PDFReadViewController alloc]init];

    //    vc.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    //    vc.PDFPagingEnabled = YES;

    //    vc.item = @"2"; //

//    vc.fileUrl = @"http://172.16.9.159:8888/002.pdf";

    [self.navigationController pushViewController:vc animated:YES];
//
//    QLPreviewController *previewController = [[QLPreviewController alloc] init];
//    previewController.dataSource = self;
//    previewController.delegate = self;
//    [self presentViewController:previewController animated:YES completion:nil];
    
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
//    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    NSString *fileName = @"保存时候的文件名，一般是url地址的最后面的文件名";
//    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    return [NSURL fileURLWithPath:@"http://172.16.9.159:8888/002.pdf"];
}

@end
