
# PDF-READ
## PDF文档阅读器,可定位到指定的页码
# 使用PDF-READ

三步完成主流App框架搭建：

 - 第一步：使用CocoaPods导入PDF-READ
 - 第二步：初始化PDFReadViewController类,同时传入文档地址
 - 第三步（可选）：设置阅读模式

# 第一步：使用CocoaPods导入PDF-READ

CocoaPods 导入

  在文件 Podfile 中加入以下内容：

    pod 'PDF-READ'
  然后在终端中运行以下命令：

    pod install
  或者这个命令：
```
  禁止升级 CocoaPods 的 spec 仓库，否则会卡在 Analyzing dependencies，非常慢
    pod install --verbose --no-repo-update
  或者
    pod update --verbose --no-repo-update
```
  完成后，CocoaPods 会在您的工程根目录下生成一个 .xcworkspace 文件。您需要通过此文件打开您的工程，而不是之前的 .xcodeproj。

# 第二步：初始化PDFReadViewController类,同时传入文档地址

```
    PDFReadViewController *vc = [[PDFReadViewController alloc]init];
    
    vc.fileUrl = @"http://172.16.9.159:8888/002.pdf"; //不能为空,可以为网络地址,也可以为本的存储地址
    
    [self.navigationController pushViewController:vc animated:YES];

    
```

# 第三步（可选）：设置阅读模式,横向,或纵向阅读,是否翻页,设置跳转指定的页码

  ```
  
    vc.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 横向,或纵向阅读
    
    vc.PDFPagingEnabled = YES;  // 是否翻页
    
    vc.item = @"2"; // 指定的页码
    
``` 
