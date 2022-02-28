import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources
import Moya

protocol RepoDetailViewModelProtocol : ViewModelProtocol {
    var userManager : UserDefaultsManager { get }
    var repo : Repo { get }
}




class RepoDetailViewModel : RepoDetailViewModelProtocol{
   
    

   
   
  
    struct Input {
        let viewWillAppear : Driver<Void>
        let linkButtonTap : Driver<UITapGestureRecognizer>
        let starAddAction : Driver<Void>
    }
    
    struct Output {
        let starred : Driver<Bool>
        let outputError : Driver<Error>
        let repo : Driver<Repo>
    }
    
    
    var coordinator : RepoDetailViewCoordinator?
    let userManager: UserDefaultsManager = UserDefaultsManager.shared
    let networkAPI : NetworkingAPI
    let disposeBag = DisposeBag()
    let repo : Repo
    
    
    
    
    
    init(networkAPI : NetworkingAPI = NetworkingAPI.shared , repo : Repo){
       
        self.networkAPI = networkAPI
        self.repo = repo
    }
    
    
    func transform(input: Input) -> Output  {
        let starred = PublishSubject<Bool>()
        let outputError = PublishSubject<Error>()
        let repo = BehaviorSubject<Repo>(value : repo)
        let starredCount = PublishSubject<Bool>()
        
        input.viewWillAppear
            .withLatestFrom(repo.asDriverOnErrorNever())
            .flatMapLatest {  repo -> Driver<Bool> in
                return self.getStarredRepos(repoLogin: repo.owner.login, repoName: repo.name)
                    .map { response in
                        return response.statusCode == 204
                    }
                    .asDriver{ _ in
                        return .just(false)
                    }
            }
            .drive(starred)
            .disposed(by: disposeBag)
  
        input.linkButtonTap
            .withLatestFrom(repo.asDriverOnErrorNever()) { return $1 }
            .drive{ [weak self] repo in
                guard let self = self  else { return }
                self.coordinator?.openSafari(url: repo.htmlURL)
            }
            .disposed(by: disposeBag)
        
        input.starAddAction
            .asObservable()
            .loginChecking()
            .withLatestFrom(starred.asDriverOnErrorNever()) { $1 }
            .withLatestFrom(repo.asDriverOnErrorNever()){ return ($0 , $1) }
            .flatMapLatest { [weak self] starred , repo -> Driver<Bool> in
                guard let self = self else { return .never() }
                if(starred){
                    return self.deleteStarredRepos(repoLogin: repo.owner.login, repoName: repo.name)
                        .map { response in
                            self.userManager.starredDelete(repo: repo)
                            return !(response.statusCode == 204)
                        }
                        .asDriver{ _ in
                            return .just(true)
                        }
                }else{
                    return self.addStarredRepos(repoLogin: repo.owner.login, repoName: repo.name)
                        .map { response in
                            self.userManager.starredAdd(repo: repo)
                            return response.statusCode == 204
                        }
                        .asDriver{ _ in
                            return .just(false)
                        }
                }
            }
            .asDriverOnErrorNever()
            .drive(starred , starredCount)
            .disposed(by: disposeBag)
        
        starredCount
            .map{ $0 == true ? 1 : -1  }
            .withLatestFrom(repo) { count , repo in
                var originalRepo = repo
                originalRepo.stargazersCount += count
                return originalRepo
            }
            .asDriverOnErrorNever()
            .drive(repo)
            .disposed(by: disposeBag)

        
        
        
        
        return .init(starred: starred.asDriverOnErrorNever() , outputError: outputError.asDriverOnErrorNever() , repo: repo.asDriverOnErrorNever())
    }
}


extension RepoDetailViewModel {
    func getStarredRepos(repoLogin : String , repoName : String) -> Single<Response>{
        networkAPI.requestSimple(.starredChecked(repoLogin: repoLogin, repoName: repoName))
     }
    
    func deleteStarredRepos(repoLogin : String , repoName : String) -> Single<Response>{
        networkAPI.requestSimple(.starredDelete(repoLogin: repoLogin, repoName: repoName))
     }
    func addStarredRepos(repoLogin : String , repoName : String) -> Single<Response>{
        networkAPI.requestSimple(.starredAdd(repoLogin: repoLogin, repoName: repoName))
     }
}
