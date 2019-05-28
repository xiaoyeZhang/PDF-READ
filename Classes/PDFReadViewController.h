//
//  PDFReadViewController.h
//  PDF-READ
//
//  Created by zhangxiaoye on 2019/5/21.
//  Copyright © 2019 zhangxiaoye. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface PDFReadViewController : UIViewController

/**
 设置文档的地址(可读网络资源,可读本地资源)
 */
@property (copy, nonatomic) NSString *fileUrl;

/**
 设置指定的页码
 */
@property (copy, nonatomic) NSString *item;

/**
 设置集合视图一页一页的翻动,默认NO
 */
@property (assign, nonatomic) BOOL PDFPagingEnabled;

/**
 设置纵向还是横向滚动,默认竖直方向
 */
@property (nonatomic) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical


@end

NS_ASSUME_NONNULL_END
