# XPTextView

[![Build](https://img.shields.io/wercker/ci/wercker/docs.svg)]()
[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=flat)]()
[![License](https://img.shields.io/badge/license-MIT-orange.svg?style=flat)]()

给UITextView扩展placelder功能

## Requirements

- Xcode8.0+
- iOS7.0+

## Usage

1. 将XPTextView文件夹拖到项目中，并导入`#import "XPTextView.h"`

2. 直接给placeholder属性赋值即可

```ObjC
XPTextView *textView = [[XPTextView alloc] initWithFrame:CGRectMake(20.0, 20.0, 200.0, 100.0)];
textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
textView.placeholder = @"Input here...";
textView.placeholderColor = [UIColor redColor];
[view addSubview:textView];
```

## License

基于MIT License进行开源，详细内容请参阅`LICENSE`文件。
