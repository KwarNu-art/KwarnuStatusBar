#import <UIKit/UIKit.h>  
  
@interface _UIStatusBar : UIView  
@property (nonatomic, strong) UIView *foregroundView;  
- (void)layoutSubviews;  
@end  
  
@interface _UIStatusBarStringView : UILabel  
@property (nonatomic, copy) NSString *originalText;  
@end  
  
static UIView *kwarnuBadge = nil;  
static UILabel *kwarnuTextLabel = nil;  
  
%hook _UIStatusBar  
  
- (void)layoutSubviews {  
    %orig;  
  
    // 1. Create Premium Frosted Capsule Badge for "kwarnu"  
    if (!kwarnuBadge) {  
        kwarnuBadge = [[UIView alloc] init];  
        kwarnuBadge.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.28];  
        kwarnuBadge.layer.cornerRadius = 11.0;  
        kwarnuBadge.layer.masksToBounds = YES;  
        kwarnuBadge.layer.borderWidth = 0.5;  
        kwarnuBadge.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25].CGColor;  
  
        // Frosted Ultra-Thin Material Blur Effect  
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialDark];  
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];  
        blurView.frame = CGRectMake(0, 0, 80, 22);  
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;  
        blurView.userInteractionEnabled = NO;  
        [kwarnuBadge addSubview:blurView];  
  
        // Tracked Luxury Label  
        kwarnuTextLabel = [[UILabel alloc] init];  
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:@"✦ KWARNU"];  
        [attrText addAttribute:NSKernAttributeName value:@(1.2) range:NSMakeRange(0, attrText.length)];  
        [attrText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9.5 weight:UIFontWeightHeavy] range:NSMakeRange(0, attrText.length)];  
        [attrText addAttribute:NSForegroundColorAttributeName value:[[UIColor whiteColor] colorWithAlphaComponent:0.95] range:NSMakeRange(0, attrText.length)];  
  
        kwarnuTextLabel.attributedText = attrText;  
        kwarnuTextLabel.textAlignment = NSTextAlignmentCenter;  
        [kwarnuBadge addSubview:kwarnuTextLabel];  
  
        [self addSubview:kwarnuBadge];  
    }  
  
    // Precise Top / Baseline Alignment for Notched & Dynamic Island iPhones  
    CGFloat topY = (self.frame.size.height > 24) ? 14.0 : 10.0;  
    CGFloat badgeWidth = 72.0;  
    CGFloat badgeHeight = 22.0;  
    kwarnuBadge.frame = CGRectMake(18.0, topY, badgeWidth, badgeHeight);  
    kwarnuTextLabel.frame = kwarnuBadge.bounds;  
    [self bringSubviewToFront:kwarnuBadge];  
  
    // 2. Optical Center Alignment for Clock  
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;  
    for (UIView *subview in self.subviews) {  
        for (UIView *child in subview.subviews) {  
            if ([child isKindOfClass:%c(_UIStatusBarStringView)]) {  
                _UIStatusBarStringView *strView = (_UIStatusBarStringView *)child;  
                if ([strView.text containsString:@":"]) {  
                    // Refined Clock Typography  
                    strView.font = [UIFont systemFontOfSize:14.5 weight:UIFontWeightSemibold];  
                    [strView sizeToFit];  
  
                    CGRect frame = strView.frame;  
                    frame.origin.x = (screenWidth - frame.size.width) / 2.0;  
                    frame.origin.y = topY + 1.5;  
                    strView.frame = frame;  
                }  
            }  
        }  
    }  
}  
  
%end  
  
// Keep clock centered dynamically when minutes update  
%hook _UIStatusBarStringView  
  
- (void)setText:(NSString *)text {  
    %orig(text);  
    if ([text containsString:@":"]) {  
        UIView *superV = self.superview;  
        if (superV) {  
            [superV setNeedsLayout];  
        }  
    }  
}  
  
%end  
