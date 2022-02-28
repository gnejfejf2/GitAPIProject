// NSNotifaction에 사용할 이름 정의
import UIKit

enum NSNotificationName: String {
    //로그인시
    case LOGIN
  
    case LOGINERROR
    
}


extension NSNotification.Name {
    static let LOGIN = NSNotification.Name("LOGIN")
    static let LOGINERROR = NSNotification.Name("LOGINERROR")
}
