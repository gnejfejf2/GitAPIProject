import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources
import Moya

protocol ProfileViewModelProtocol : SuperScrollPagingProtocol , ViewModelProtocol  {
    var coordinator : ProfileViewCoordinator? { get set }
    var userManager : UserDefaultsManager { get }
    var loginManager : LoginManager { get }
    func userInfoGet() -> Single<UserInfoResponse?>
    func getStarredRepos() -> Single<Repos>
}




class ProfileViewModel : SuperScrollPagingProtocol , ProfileViewModelProtocol{
   
    
    struct Input {
        let viewWillAppear : Driver<Void>
        let loginAction : Driver<Void>
        let loginUpdate : Driver<Notification>
        let loginError : Driver<String>
        let repositoryTapAction : Driver<Repo>
        let pullToScroll : Driver<Void>
        let bottomScrollTriger : Driver<Void>
    }
    
    struct Output {
        let userInfo : Driver<UserInfoResponse?>
        let starredRepos : Driver<Repos>
        let outputError : Driver<Error>
        let loading : Driver<Bool>
    }
    
    
    var coordinator : ProfileViewCoordinator?
    let networkAPI : NetworkingAPI
    let userManager : UserDefaultsManager = UserDefaultsManager.shared
    let loginManager : LoginManager = LoginManager.shared
    let disposeBag = DisposeBag()
    
    
    
    
    init(networkAPI : NetworkingAPI = NetworkingAPI.shared){
        self.networkAPI = networkAPI
    }
    
    
    func transform(input: Input) -> Output  {
        let repos = PublishSubject<Repos>()
        let accessToken = BehaviorSubject<String>(value: userManager.accessToken)
        let outputError = PublishSubject<Error>()
        let userInfo = PublishSubject<UserInfoResponse?>()
        let loading = PublishSubject<Bool>()
        
        
        input.bottomScrollTriger
            .filter{ [weak self] _ in
                guard let self = self else { return false }
                return self.userManager.accessToken != ""
            }
            .compactMap{ $0 }
            .map{ self.settingLoading(loading: loading , on: true , $0) }
            .flatMapLatest{ [weak self]  _ -> Driver<Repos> in
                guard let self = self else { return .never() }
                return self.getStarredRepos()
                    .asDriver(onErrorRecover: { error  in
                        outputError.onNext(error)
                        return .empty()
                    })
            }
            .map{ self.settingLoading(loading: loading , on: false , $0) }
            .withLatestFrom(repos.asDriverOnErrorNever()) { $1 + $0 }
            .drive(repos)
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .asObservable()
            .withLatestFrom(repos) { $1 }
            .localStarredSync()
            .drive(repos)
            .disposed(by: disposeBag)
        
        input.loginAction
            .withLatestFrom(accessToken.asDriverOnErrorNever()) { return $1 }
            .drive { [weak self] key in
                guard let self = self else { return }
                if(key == ""){
                    self.loginManager.requestCode()
                }else{
                    self.userManager.accessToken = ""
                    accessToken.onNext("")
                }
            }
            .disposed(by: disposeBag)
        
        
        input.loginUpdate
            .map{ [weak self] _ in
                guard let self = self else { return "" }
                return self.userManager.accessToken
            }
            .drive(accessToken)
            .disposed(by: disposeBag)
        
        
        accessToken
            .filter{ $0 != "" }
            .loginChecking()
            .map{ self.settingLoading(loading: loading , on: true , $0) }
            .flatMapLatest{ [weak self]  _ -> Observable<UserInfoResponse?> in
                guard let self = self else { return .never() }
                return self.userInfoGet()
                    .asObservable()
                    .catch { error in
                        outputError.onNext(error)
                        return Observable<UserInfoResponse?>.never()
                    }
            }
            .map{ self.settingLoading(loading: loading , on: false , $0) }
            .subscribe(userInfo)
            .disposed(by: disposeBag)
            
        accessToken
            .filter{ $0 == "" }
            .map{ _ in nil }
            .subscribe(userInfo)
            .disposed(by: disposeBag)
        
        
        userInfo
            .compactMap{ $0 }
            .map{ self.settingLoading(loading: loading , on: true , $0) }
        
            .flatMapLatest{ [weak self]  userinfo -> Driver<Repos> in
                guard let self = self else { return .never() }
                self.pagingCountClear()
                return self.getStarredRepos()
                    .asDriver(onErrorRecover: { error  in
                        outputError.onNext(error)
                        return .empty()
                    })
            }
            .map{ self.settingLoading(loading: loading , on: false , $0) }
            .asDriverOnErrorNever()
            .drive(repos)
            .disposed(by: disposeBag)
        
        input.repositoryTapAction
            .asObservable()
            .subscribe { [weak self] repo in
                guard let self = self else { return }
                guard let repo = repo.element else { return }
                self.coordinator?.repoDetailOpen(repo: repo)
            }.disposed(by: disposeBag)
        
        input.pullToScroll
            .withLatestFrom(userInfo.asDriverOnErrorNever()) { $1 }
            .flatMapLatest{ [weak self]  userinfo -> Driver<Repos> in
                guard let self = self else { return .never() }
                self.pagingCountClear()
                return self.getStarredRepos()
                    .asDriver(onErrorRecover: { error  in
                        outputError.onNext(error)
                        return .empty()
                    })
            }
            .drive(repos)
            .disposed(by: disposeBag)
        
        
      
    
        
        
        return Output(userInfo : userInfo.asDriverOnErrorNever()  , starredRepos : repos.asDriverOnErrorNever() , outputError : outputError.asDriverOnErrorNever() , loading : loading.asDriverOnErrorNever())
    }
}




extension ProfileViewModelProtocol {
    func userInfoGet() -> Single<UserInfoResponse?>{
        networkAPI.request(type : UserInfoResponse?.self , .getUserInfo)
    }
    
    func getStarredRepos() -> Single<Repos>{
        //페이징카운트가 0이면 새롭게 조회하는거기때문에 Starred 를 삭제시켜줘도됨
        if(pagingCount == 0){
            userManager.clearRemoveList()
        }
         return networkAPI.request(type : Repos.self , .getUserStarredRepos(itemCount: itemCount, pagingCount: pagingCount))
            .map{ [weak self] item in
                guard let self = self else { return [] }
                self.pagingCountChecking(requestItemCount: item.count)
                return item
            }
     }
     

    
}


