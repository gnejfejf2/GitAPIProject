import RxSwift
import RxCocoa

public extension Reactive where Base: UIScrollView {
   
    //ScrollView의 위치에 따라 컨트롤 이벤트를 리턴하는 함수
    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { contentOffset in
            let visibleHeight = self.base.frame.height - self.base.contentInset.top - self.base.contentInset.bottom
            let y = contentOffset.y + self.base.contentInset.top
            let threshold = max(offset, self.base.contentSize.height - visibleHeight)
            return y >= threshold
        }
        .distinctUntilChanged()
        .filter { $0 }
        .map { _ in () }
        return ControlEvent(events: source)
    }
}



extension ObservableType {
   func asDriverOnErrorNever() -> Driver<Element> {
        return asDriver { (error) in
            return .never()
        }
    }
    
    func loginChecking() -> Observable<Element> {
       
        
        
        
        return self.filter{ _ in
            if(UserDefaultsManager.shared.accessToken == ""){
                let alert = UIAlertController(title: "로그인", message: "로그인이 필요합니다." , preferredStyle: .alert)
                let success = UIAlertAction(title: "확인", style: .default)
                alert.addAction(success)
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                return false
            }else{
                
                return true
            }
        }
     }
    
   
    
}



extension ObservableType where Element == Repos {
    func localStarredSync() -> Driver<Repos> {
        return self.asObservable()
            .map{ $0.filter{!UserDefaultsManager.shared.starredRemoveList.contains($0)} }
            .map{ item -> Repos in
                return item + UserDefaultsManager.shared.starredAddList.filter{!item.contains($0)}
            }
            .map{
                UserDefaultsManager.shared.clearRemoveList()
                return $0
            }
            .asDriverOnErrorNever()
    }
}
