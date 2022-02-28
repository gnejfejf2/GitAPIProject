
import Alamofire
import UIKit

class LoginManager {
    
    static let shared = LoginManager()
    
    private init() {}
    
    let client_id = "3b3d0a79783a63851478"
    let client_secret = "d441a15daaa30380333abc3f2fef8fd27c2ddb7d"
    
    func requestCode() {
        let scope = "repo,user"
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(client_id)&scope=\(scope)"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            // redirect to scene(_:openURLContexts:) if user authorized
        }
    }
    
   
    
    func logout() {
//        KeychainSwift().clear()
    }
}
