
import UIKit


extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}

extension UIButton {
    
    func innerPadding(top : CGFloat, leading : CGFloat, bottom : CGFloat, trailing : CGFloat ){
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.contentInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
            self.configuration = configuration
        } else {
            self.contentEdgeInsets = UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
          
        }
    }
    
    func backGroundColorSetting(color : UIColor){
        if #available(iOS 15.0, *) {
            self.configuration?.baseBackgroundColor = color
        } else {
            self.backgroundColor = color
        }
    }
    
    func setFont(font : UIFont){
        if #available(iOS 15.0, *) {
            var container = AttributeContainer()
            container.font = font
            self.configuration?.attributedTitle = AttributedString(self.titleLabel?.text ?? "", attributes: container)
        } else {
            self.titleLabel?.font = font
        }
        
    }
}
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
