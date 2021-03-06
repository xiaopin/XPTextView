//
//  XPTextView.h
//
//
//  https://github.com/xiaopin/XPTextView.git
//

#import <UIKit/UIKit.h>

NS_CLASS_AVAILABLE_IOS(8_0) /*IB_DESIGNABLE*/ @interface XPTextView : UITextView

/// 占位符文本
@property (nonatomic, copy) IBInspectable NSString *placeholder;
/// 占位符文本颜色
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
/// 是否禁用回车符,默认`NO`
@property (nonatomic, assign, getter=isDisableReturnCharacter) IBInspectable BOOL disableReturnCharacter;

@end
