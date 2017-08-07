//
//  XPTextView.h
//
//
//  https://github.com/xiaopin/XPTextView.git
//

#import <UIKit/UIKit.h>

@interface XPTextView : UITextView

/// 占位符文本
@property (nonatomic, copy) NSString *placeholder;
/// 占位符文本颜色
@property (nonatomic, strong) UIColor *placeholderColor;

@end
