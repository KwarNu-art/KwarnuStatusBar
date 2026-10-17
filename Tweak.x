#import <UIKit/UIKit.h>  
  
@interface _UIStatusBar : UIView  
@end  
  
@interface _UIStatusBarStringView : UILabel  
@end  
  
%hook _UIStatusBar  
  
- (void)layoutSubviews {  
    %orig;  
  
    for (UIView *subview in self.subviews) {  
        if ([subview isKindOfClass:%c(_UIStatusBarStringView)]) {  
            UILabel *label = (UILabel *)subview;  
            if ([label.text containsString:@":"]) {  
                CGPoint center = label.center;  
                center.x = self.bounds.size.width / 2.0;  
                label.center = center;  
            }  
        }  
    }  
}  
  
%end  
