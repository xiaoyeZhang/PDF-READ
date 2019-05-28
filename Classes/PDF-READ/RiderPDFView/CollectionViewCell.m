//
//  CollectionViewCell.m
//  PDF-READ
//
//  Created by zhangxiaoye on 2019/5/21.
//  Copyright © 2019 zhangxiaoye. All rights reserved.
//

#import "CollectionViewCell.h"

#import "RiderPDFView.h"
@interface CollectionViewCell()<UIScrollViewDelegate>//遵守UISCrollViewDelegate协议，这样才能实现缩放

@end
@implementation CollectionViewCell

//重写init方法

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self= [super initWithFrame:frame]) {
        
        _contentScrollView= [[UIScrollView alloc] initWithFrame:self.bounds];//初始化_contentScrollView
        
        _contentScrollView.contentSize = frame.size;//设置_contentScrollView的内容尺寸
        
        _contentScrollView.minimumZoomScale=0.5;//设置最小缩放比例
        
        _contentScrollView.maximumZoomScale=2.5;//设置最大的缩放比例
        
        _contentScrollView.delegate = self;//设置代理
        
        [self.contentView addSubview:_contentScrollView];//将_contentScrollView添加到CollectionViewCell中
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellClicked)];//创建手势
        
        [self addGestureRecognizer: tapGes];//添加手势到CollectionViewCell上
        
    }
    
    return self;
    
}

//这是scrollView的代理方法，实现后才能通过scrollView实现缩放

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView {
    
    for(UIView*view in scrollView.subviews) {
        
        if([view isKindOfClass:[RiderPDFView class]]) {
            
            return view;//返回需要被缩放的视图
            
        }
        
    }
    
    return nil;
    
}



//重写set方法

- (void)setShowView:(UIView*)showView {
    
    for(UIView *tempView in _contentScrollView.subviews) {
        
        [tempView removeFromSuperview];//移除_contentScrollView中的所有视图
        
    }
    
    _showView = showView;//赋值
    
    [_contentScrollView addSubview:showView];//将需要显示的视图添加到_contentScrollView上
    
}

//tap事件

- (void)cellClicked {
    
    if([self.cellTapDelegate respondsToSelector:@selector(collectioncellTaped:)]) {
        
        [self.cellTapDelegate collectioncellTaped:self];
        
    }
    
}
@end
