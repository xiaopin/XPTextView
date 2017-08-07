//
//  XPTextView.m
//
//
//  https://github.com/xiaopin/XPTextView.git
//

#import "XPTextView.h"

@interface XPTextView ()

/// 提示占位符标签
@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation XPTextView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [self standardInitialization];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self standardInitialization];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)textDidChangeNotificationAction:(NSNotification *)sender {
    _placeholderLabel.hidden = self.hasText;
}

#pragma mark - Private

- (void)standardInitialization {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotificationAction:) name:UITextViewTextDidChangeNotification object:self];
    [self addSubview:self.placeholderLabel];
    [self relayoutPlaceholderLabel];
}

- (void)relayoutPlaceholderLabel {
    for (NSLayoutConstraint *layout in self.constraints) {
        if (layout.firstItem == _placeholderLabel) {
            [self removeConstraint:layout];
        }
    }
    
    _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
    CGFloat contentWidth = self.frame.size.width - self.textContainerInset.left - self.textContainerInset.right - lineFragmentPadding * 2;
    NSDictionary *map = @{@"label": _placeholderLabel};
    NSDictionary *metrics = @{
                              @"top": @(self.textContainerInset.top),
                              @"left": @(self.textContainerInset.left + lineFragmentPadding),
                              @"right": @(self.textContainerInset.right + lineFragmentPadding),
                              @"bottom": @(self.textContainerInset.bottom),
                              @"width": @(contentWidth)
                              };
    NSArray<NSLayoutConstraint *> *horizontalLayout = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[label(==width)]-right-|" options:0 metrics:metrics views:map];
    NSArray<NSLayoutConstraint *> *verticalLayout = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[label]-bottom-|" options:0 metrics:metrics views:map];
    [self addConstraints:horizontalLayout];
    [self addConstraints:verticalLayout];
}

#pragma mark - setter & getter

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];
    [self relayoutPlaceholderLabel];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    _placeholderLabel.textAlignment = textAlignment;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    _placeholderLabel.font = font;
}

- (UILabel *)placeholderLabel {
    if (nil == _placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.font = self.font ?: [UIFont systemFontOfSize:14.0];
        _placeholderLabel.lineBreakMode = self.textContainer.lineBreakMode;
        _placeholderLabel.textAlignment = self.textAlignment;
        _placeholderLabel.textColor = [UIColor grayColor];
        _placeholderLabel.numberOfLines = 0;
    }
    return _placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholderLabel.text = placeholder;
}

- (NSString *)placeholder {
    return _placeholderLabel.text;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor {
    return _placeholderLabel.textColor;
}

@end