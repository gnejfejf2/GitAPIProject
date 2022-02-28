
import UIKit

extension UIViewController {
    func navigationBarTitleSetting(_ title : String){
        navigationController?.navigationBar.topItem?.title = title
    }
    
    func navigationBarSetting(hidden : Bool = false){
        if(hidden) {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }else{
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.navigationBar.backItem?.title = ""
            navigationController?.navigationBar.tintColor = .primaryColorReverse
         
        }
    }
}
