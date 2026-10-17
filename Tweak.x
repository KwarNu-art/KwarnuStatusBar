#import <UIKit/UIKit.h>  
  
@interface _UIStatusBar : UIView  
@property (nonatomic, strong) UIView *foregroundView;  
- (void)layoutSubviews;  
@end  
  
@interface _UIStatusBarStringView : UILabel  
@property (nonatomic, copy) NSString *originalText;  
@end  
  
@interface _UIStatusBarTimeItem : NSObject  
@property (nonatomic, strong) _UIStatusBarStringView *shortTimeView;  
@end  
  
// Custom Branding Label  
static UILabel *kwarnuLabel = nil;  
  
%hook _UIStatusBar  
  
- (void)layoutSubviews {  
    %orig;  
  
    // 1. Add Custom "kwarnu" Label to the Left (Leading)  
    if (!kwarnuLabel) {  
        kwarnuLabel = [[UILabel alloc] init];  
        kwarnuLabel.text = @"kwarnu";  
        kwarnuLabel.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightBold];  
        kwarnuLabel.textColor = [UIColor whiteColor];  
        kwarnuLabel.alpha = 0.9;  
        [self addSubview:kwarnuLabel];  
    }  
  
    // Dynamic padding calculation for Notch & Dynamic Island devices  
    CGFloat topPadding = 12.0;  
    if (self.frame.size.height > 24) {  
        // Notched / Dynamic Island Devices  
        topPadding = 14.0;  
    }  
    kwarnuLabel.frame = CGRectMake(24.0, topPadding, 60.0, 18.0);  
    [self bringSubviewToFront:kwarnuLabel];  
  
    // 2. Locate and Center the Clock / Time View  
    for (UIView *subview in self.subviews) {  
        for (UIView *child in subview.subviews) {  
            if ([child isKindOfClass:%c(_UIStatusBarStringView)]) {  
                _UIStatusBarStringView *strView = (_UIStatusBarStringView *)child;  
  
                // Check if this label contains the time format (contains ":" or digits)  
                if ([strView.text containsString:@":"]) {  
                    CGRect frame = strView.frame;  
                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;  
  
                    // Horizontally center the clock  
                    frame.origin.x = (screenWidth - frame.size.width) / 2.0;  
                    strView.frame = frame;  
                }  
            }  
        }  
    }  
}  
  
%end  
  
// Hook time text change to re-trigger centering layout on minute updates  
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
