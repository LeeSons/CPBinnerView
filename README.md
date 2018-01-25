# CPBinnerView
一个轮播图控件，可实现多种轮播，无限轮播
像系统的 TableView一样去使用它

```
// 遵守 <CPBinnerViewDataSource, CPBinnerViewDelegate>协议

_binnerView = [[CPBinnerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _binnerView.delegate = self;
    _binnerView.dataSource = self;
    // 注册cell
    [_binnerView registerClass:[CPBinnerCell class] forCellWithReuseIdentifier:@"cell"];
    // 你也可以使用nib注册cell
    [_binnerView registerNib:[UINib nibWithNibName:@"BinnerCell2" bundle:nil] forCellWithReuseIdentifier:@"cell2"];
```
实现协议方法

```
- (NSInteger)numberOfItemsWithBinnerView:(CPBinnerView *)binnerView;
- (CPBinnerCell *)binnerView:(CPBinnerView *)binnerView itemForIndex:(NSInteger)index;
```

## cell样式完全可以自定义，来实现各种各样的轮播效果。

![CPBinnerView](https://github.com/LeeSons/CPBinnerView/blob/master/screen.gif)
