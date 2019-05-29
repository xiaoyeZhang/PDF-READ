//
//  PDFReadViewController.m
//  PDF-READ
//
//  Created by zhangxiaoye on 2019/5/21.
//  Copyright © 2019 zhangxiaoye. All rights reserved.
//

#import "PDFReadViewController.h"
#import <Masonry/Masonry.h>
#import "CollectionViewCell.h"//导入自定义的CollectionViewCell
#import "RiderPDFView.h"//导入展示PDF文件内容的View

//RGB Color
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

static NSString *cellIdentifier = @"CollectionViewCell";

@interface PDFReadViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,collectionCellDelegate>//遵守协议
{
    
    CGPDFDocumentRef _docRef; //需要获取的PDF资源文件
    CGPDFDocumentRef document;
}

@property(nonatomic,strong) UICollectionView *CollectionView; //展示用的CollectionView

@property(nonatomic,strong) NSMutableArray *dataArray;//存数据的数组

@property(nonatomic,assign) int totalPage;//一共有多少页

@property (strong, nonatomic) UILabel *numLable;

@property (assign, nonatomic) CGFloat TopHeight;

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@property (nonatomic,strong) UIView *noDataView;

@end

@implementation PDFReadViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
//    [SVProgressHUD dismiss];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.TopHeight = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;

    [self.view addSubview:self.CollectionView];//将集合视图添加到当前视图上

    [self.CollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.TopHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.frame.size.height-self.TopHeight);
    }];

    [self addNumLable];
    
    [self readPDF:self.fileUrl];

}

- (UICollectionView *)CollectionView{
    
    if (!_CollectionView) {
        
        
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        
        self.layout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.frame.size.height-self.TopHeight);

        [self.layout setScrollDirection:self.scrollDirection];//设置滑动方向为水平方向，也可以设置为竖直方向
        
        self.layout.minimumLineSpacing = 0;//设置item之间最下行距
        
        self.layout.minimumInteritemSpacing = 0;//设置item之间最小间距
        
        _CollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        
        _CollectionView.backgroundColor = [UIColor whiteColor];
        _CollectionView.pagingEnabled = self.PDFPagingEnabled;//设置集合视图一页一页的翻动
        _CollectionView.delegate = self;
        _CollectionView.dataSource = self;
        
        [_CollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];

    }
    
    return _CollectionView;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)addNumLable{
    
    self.numLable = [[UILabel alloc]init];
    
    self.numLable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.numLable.textAlignment = NSTextAlignmentCenter;
    
    self.numLable.layer.masksToBounds = YES;
    self.numLable.layer.cornerRadius = 10;
    
    self.numLable.text = @"";
    
    [self.view addSubview:self.numLable];
    
    [self.numLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.TopHeight + 20);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    
}

/**
 默认的占位图
 */
- (void)xy_defaultNoDataViewWithImage:(UIImage *)image message:(NSString *)message color:(UIColor *)color offsetY:(CGFloat)offset {

    //  计算位置, 垂直居中, 图片默认中心偏上.
    CGFloat sW = self.view.bounds.size.width;
    CGFloat cX = sW / 2;
    CGFloat cY = self.view.bounds.size.height * (1 - 0.618) + offset;
    CGFloat iW = image.size.width;
    CGFloat iH = image.size.height;
    
    //  图片
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame        = CGRectMake(cX - iW / 2, cY - iH / 2, iW, iH);
    imgView.image        = image;
    
    //  文字
    UILabel *label       = [[UILabel alloc] init];
    label.numberOfLines  = 0;
    label.font           = [UIFont systemFontOfSize:15];
    label.textColor      = color;
    label.text           = message;
    label.textAlignment  = NSTextAlignmentCenter;
//    label.frame          = CGRectMake(0, CGRectGetMaxY(imgView.frame) + 24, sW, label.font.lineHeight);
    
    //  视图
    while (self.noDataView.subviews.count) {
        [self.noDataView.subviews.lastObject removeFromSuperview];
    }
    [self.noDataView addSubview:imgView];
    [self.noDataView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(CGRectGetMaxY(imgView.frame) + 24);
        make.width.mas_equalTo(sW);
    }];
}


- (void)readPDF:(NSString *)pdfName{
    
//    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *FilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",pdfName]];
    
    self.navigationItem.title =  [[pdfName lastPathComponent] stringByDeletingPathExtension];
    
    _docRef = [self pdfRefByDataByUrl:pdfName];
    
    [self getDataArrayValue];
    
    [self.CollectionView reloadData];
    
    [self skipPage];

    self.CollectionView.backgroundColor = [UIColor whiteColor];

    self.CollectionView.backgroundView = nil;

    if (self.dataArray.count > 0) {
        
        if (self.item.length > 0) {
            
            [self skipPage];
            
            self.numLable.text = [NSString stringWithFormat:@"%d of %lu",[self.item intValue]+1,(unsigned long)self.dataArray.count];
        }else{
            
            self.numLable.text = [NSString stringWithFormat:@"%@ of %lu",@"1",(unsigned long)self.dataArray.count];
        }
        
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];

    }else{
        
        self.numLable.hidden = YES;
        
        self.CollectionView.backgroundColor = RGBCOLOR(230, 230, 230, 1);
        
        self.noDataView = [[UIView alloc] init];
        
        [self xy_defaultNoDataViewWithImage:nil message:[NSString stringWithFormat:@"%@\nPDF doument",(self.navigationItem.title?self.navigationItem.title:@"")] color:RGBCOLOR(153, 153, 153, 1) offsetY:0];

        self.CollectionView.backgroundView = self.noDataView;
        
    }

}

- (void)skipPage{
    
    
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionVertical:
            {
                CGFloat offsetY = [self.item integerValue] * self.CollectionView.frame.size.height;

                [self.CollectionView setContentOffset:CGPointMake(0, offsetY)];
            }
            break;
        case UICollectionViewScrollDirectionHorizontal:
            {
                CGFloat offsetX = [self.item integerValue] * self.CollectionView.frame.size.width;

                [self.CollectionView setContentOffset:CGPointMake(offsetX, 0)];
            }

            break;
        default:
            break;
    }
    
    [self.CollectionView layoutIfNeeded];
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    //1.根据偏移量判断一下应该显示第几个item

    CGFloat offSetItem;
    CGFloat itemHeight;
    
    switch (self.scrollDirection) {
        case UICollectionViewScrollDirectionVertical:
            offSetItem = targetContentOffset->y;
            itemHeight = self.view.frame.size.height-self.TopHeight;
            break;
        case UICollectionViewScrollDirectionHorizontal:
            offSetItem = targetContentOffset->x;
            itemHeight = self.view.frame.size.width;

            break;
        default:
            break;
    }
    
    //item的宽度+行间距 = 页码的宽度
    NSInteger pageHright = itemHeight;
    
    //根据偏移量计算是第几页
    NSInteger pageNum = (offSetItem + pageHright/2)/pageHright;
    
    self.numLable.alpha = 1.0;

    self.numLable.text = [NSString stringWithFormat:@"%ld of %lu",pageNum +1,(unsigned long)self.dataArray.count];
}

//用于读取pdf文件
- (CGPDFDocumentRef)pdfRefByDataByUrl:(NSString *)aFileUrl {
    
    NSData *pdfData;
    
    if ([aFileUrl hasPrefix:@"http://"] || [aFileUrl hasPrefix:@"https://"]) {
     
        pdfData = [NSData dataWithContentsOfURL:[NSURL URLWithString:aFileUrl]];

    }else{
        
        pdfData = [NSData dataWithContentsOfFile:aFileUrl];

    }

    CFDataRef dataRef = (__bridge_retained CFDataRef)(pdfData);

    CGDataProviderRef proRef = CGDataProviderCreateWithCFData(dataRef);
    CGPDFDocumentRef pdfRef = CGPDFDocumentCreateWithProvider(proRef);

    CGDataProviderRelease(proRef);
    
    if (dataRef == nil) {
    
        return nil;
    
    }
    
    CFRelease(dataRef);


    return pdfRef;
    
}

//获取所有需要显示的PDF页面

- (void)getDataArrayValue {
    
    size_t totalPages = CGPDFDocumentGetNumberOfPages(_docRef);//获取总页数

    self.totalPage= (int)totalPages;//给全局变量赋值

    NSMutableArray *arr = [NSMutableArray new];
    
    //通过循环创建需要显示的PDF页面，并把这些页面添加到数组中
    
    for(int i =1; i <= totalPages; i++) {

        RiderPDFView *view = [[RiderPDFView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height-self.TopHeight) documentRef: _docRef andPageNum:i];

        [arr addObject:view];

    }

    self.dataArray= arr;//给数据数组赋值
    
}

//返回集合视图共有几个分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {

    return 1;

}

//返回集合视图中一共有多少个元素——自然是总页数

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.totalPage;
    
}

//复用、返回cell

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    cell.cellTapDelegate = self;//设置tap事件代理
    
    cell.showView = self.dataArray[indexPath.row];//赋值，设置每个item中显示的内容
    
    return cell;
    
}

//当集合视图的item被点击后触发的事件，根据个人需求写
- (void)collectioncellTaped:(CollectionViewCell*)cell {


    NSLog(@"我点了咋的？");
}

//集合视图继承自scrollView，所以可以用scrollView 的代理事件，这里的功能是当某个item不在当前视图中显示的时候，将它的缩放比例还原

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    
    for(UIView *view in self.CollectionView.subviews) {
        
        if([view isKindOfClass:[CollectionViewCell class]]) {
            
            CollectionViewCell*cell = (CollectionViewCell*)view;
            
            [cell.contentScrollView setZoomScale:1.0];
            
        }
    }
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    [UIView animateWithDuration:1.0 animations:^{
        
        self.numLable.alpha = 1.0;
        
    }];
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];

}

- (void)delayMethod{
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.numLable.alpha = 0.0;

    }];
    
}

@end
