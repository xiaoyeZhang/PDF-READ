//
//  RiderPDFView.h
//  PDF-READ
//
//  Created by zhangxiaoye on 2019/5/21.
//  Copyright © 2019 zhangxiaoye. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiderPDFView : UIView

//写一个方法，通过Frame、已经获取到的CGPDFDocumentRef文件和需要显示的PDF文件的页码，来创建一个显示PDF文件内容的视图

- (instancetype)initWithFrame:(CGRect)frame documentRef:(CGPDFDocumentRef)docRef andPageNum:(int)page;



@end

NS_ASSUME_NONNULL_END
