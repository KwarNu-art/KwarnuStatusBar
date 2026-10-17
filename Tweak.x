#import <UIKit/UIKit.h>  
  
@interface _UIStatusBar : UIView  
@end  
  
static UILabel *kwarnuLabel = nil;  
  
%hook _UIStatusBar  
  
- (void)layoutSubviews {  
    %orig;  
  
    CGFloat barWidth = self.bounds.size.width;  
    CGFloat barHeight = self.bounds.size.height;  
  
    // ၁။ ဘယ်ဘက် အစွန်းတွင် "kwarnu" branding text ထည့်သွင်းခြင်း  
    if (!kwarnuLabel || kwarnuLabel.superview != self) {  
        [kwarnuLabel removeFromSuperview];  
        kwarnuLabel = [[UILabel alloc] init];  
        kwarnuLabel.text = @"kwarnu";  
  
        // သေသပ်လှပသော Font (HelveticaNeue Light Italic)  
        UIFont *customFont = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:11.5];  
        if (!customFont) {  
            customFont = [UIFont italicSystemFontOfSize:11.5];  
        }  
        kwarnuLabel.font = customFont;  
        kwarnuLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.92]; // Clean Soft White  
        kwarnuLabel.tag = 99991;  
        [self addSubview:kwarnuLabel];  
    }  
  
    // "kwarnu" Label အနေအထား သတ်မှတ်ခြင်း  
    [kwarnuLabel sizeToFit];  
    CGFloat leftPadding = 24.0; // ဘယ်ဘက် notch/screen corner နှင့် လွတ်စေရန်  
    kwarnuLabel.frame = CGRectMake(leftPadding, (barHeight - kwarnuLabel.frame.size.height) / 2.0, kwarnuLabel.frame.size.width, kwarnuLabel.frame.size.height);  
    [self bringSubviewToFront:kwarnuLabel];  
  
    // ၂။ Time/Clock ကို ရှာဖွေပြီး Screen ၏ အလယ်တည့်တည့်သို့ ပို့ခြင်း  
    for (UIView *subview in self.subviews) {  
        if ([subview isKindOfClass:[UILabel class]] && subview != kwarnuLabel) {  
            UILabel *lbl = (UILabel *)subview;  
            if ([lbl.text containsString:@":"]) {  
                lbl.center = CGPointMake(barWidth / 2.0, barHeight / 2.0);  
                [self bringSubviewToFront:lbl];  
            }  
        }  
  
        // Subview အတွင်းပိုင်းတွင် ရှိနေပါက ထပ်မံစစ်ဆေးခြင်း  
        for (UIView *child in subview.subviews) {  
            if ([child isKindOfClass:[UILabel class]]) {  
                UILabel *lbl = (UILabel *)child;  
                if ([lbl.text containsString:@":"]) {  
                    CGPoint centerInParent = [self convertPoint:CGPointMake(barWidth / 2.0, barHeight / 2.0) toView:subview];  
                    lbl.center = centerInParent;  
                }  
            }  
        }  
    }  
}  
  
%end
