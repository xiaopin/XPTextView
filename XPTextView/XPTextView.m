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

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    [self standardInitialization];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if DEBUG
    NSLog(@"%s", __FUNCTION__);
#endif
}

#pragma mark - Actions

- (void)textDidChangeNotificationAction:(NSNotification *)sender {
    _placeholderLabel.hidden = self.hasText;
    if (_disableReturnCharacter && self.hasText && [self.text containsString:@"\n"]) {
        NSInteger index = [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
        NSString *character = [self.text substringWithRange:NSMakeRange(index-1, 1)];
        if ([character isEqualToString:@"\n"]) {
            self.text = [[self.text componentsSeparatedByString:@"\n"] componentsJoinedByString:@""];
            if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
                [self.delegate textViewDidChange:self];
            }
            [self resignFirstResponder];
        }
    }
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
            [layout setActive:NO];
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
    [NSLayoutConstraint activateConstraints:horizontalLayout];
    [NSLayoutConstraint activateConstraints:verticalLayout];
}

#pragma mark - setter & getter

- (void)setText:(NSString *)text {
    [super setText:text];
    _placeholderLabel.hidden = self.hasText;
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];
    [self relayoutPlaceholderLabel];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    self.placeholderLabel.textAlignment = textAlignment;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
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
    self.placeholderLabel.text = placeholder;
}

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor {
    return self.placeholderLabel.textColor;
}

- (void)setDisableReturnCharacter:(BOOL)disableReturnCharacter {
    _disableReturnCharacter = disableReturnCharacter;
    self.returnKeyType = disableReturnCharacter ? UIReturnKeyDone : UIReturnKeyDefault;
}

@end
