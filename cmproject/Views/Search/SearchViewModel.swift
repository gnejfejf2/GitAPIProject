import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources
import Moya

protocol SearchViewModelProtocol : ViewModelProtocol , ScrollPagingProtocl {
    var coordinator: SearchViewCoordinator? { get set }
    func getRepos(keyword : String) -> Single<Repos>
}


class SearchViewModel :  SearchViewModelProtocol{
    
    
    
    struct Input {
        let searchKeyword : Driver<String>
        let searchAction : Driver<Void>
        let bottomScrollTriger : Driver<Void>
        let repositoryTapAction : Driver<Repo>
    }
    
    struct Output {
        let starredRepos : Driver<Repos>
        let searchKeyword : Driver<String>
        let loading : Driver<Bool>
    }
    
    var coordinator: SearchViewCoordinator?
    let networkAPI : NetworkingAPI
    
    
    
 
    
    var totalCount: Int = 0
    
    let itemCount: Int = 30
    //스크롤 에따른 페이징 체크
    var scrollPagingCall : Bool = true
    //페이징 카운트
    var pagingCount : Int = 1
    
    
    let disposeBag = DisposeBag()
    
    
    init(networkAPI : NetworkingAPI = NetworkingAPI.shared){
        self.networkAPI = networkAPI
        
    }
    
    //확인버튼 searchAction 들어오면
    //해당값이 검색키워드가되고
    //들어온 키워드를 기반으로 검색을 시작한다.
    //해당 검색값을 계속 유지하고있는데 (infinityScroll을 검색할때 사용해야한다.)
    func transform(input: Input) -> Output  {
        let repos = PublishSubject<Repos>()
        let searchKeyword = PublishSubject<String>()
        let loading = PublishSubject<Bool>()
        
        input.searchAction
            .withLatestFrom(input.searchKeyword)
            //똑같은 값을가지고 검색이 이뤄진다면 굳이 검색이 이뤄질 필요는 없어보인다.
            .distinctUntilChanged()
            .drive(searchKeyword)
            .disposed(by: disposeBag)
        
        searchKeyword
            .filter{ $0 != "" }
            .map{ self.settingLoading(loading: loading , on: true , $0) }
            .flatMapLatest{ [weak self]  keyword -> Driver<Repos> in
                guard let self = self else { return Driver.empty() }
                //새로운 검색이 시작되었기때문에 페이징을 초기화시킨다.
                self.pagingCountClear()
                return self.getRepos(keyword: keyword)
                    .asDriver(onErrorRecover: { error  in
                        return .empty()
                    })
            }
            .map{ self.settingLoading(loading: loading , on: false , $0) }
            .asDriverOnErrorNever()
            .drive(repos)
            .disposed(by: disposeBag)
 
        input.bottomScrollTriger
            .withLatestFrom(searchKeyword.asDriverOnErrorNever())
            .map{ self.settingLoading(loading: loading , on: true , $0) }
            .flatMapLatest{ [weak self]  keyword -> Driver<Repos> in
                guard let self = self else { return Driver.empty() }
                return self.getRepos(keyword: keyword)
                    .asDriver(onErrorRecover: { error  in
                        return .empty()
                    })
            }
            .map{ self.settingLoading(loading: loading , on: false , $0) }
            .withLatestFrom(repos.asDriverOnErrorNever()) { $1 + $0 }
            .drive(repos)
            .disposed(by: disposeBag)
        
        
        input.repositoryTapAction
            .asObservable()
            .subscribe { [weak self] repo in
                guard let self = self else { return }
                guard let repo = repo.element else { return }
                self.coordinator?.repoDetailOpen(repo: repo)
            }.disposed(by: disposeBag)

            
        
        
        return Output(starredRepos : repos.asDriverOnErrorNever() , searchKeyword : searchKeyword.asDriverOnErrorNever(), loading: loading.asDriverOnErrorNever())
    }
    

}




extension SearchViewModelProtocol {
    
    
    func getRepos(keyword : String ) -> Single<Repos>{
        networkAPI.request(type : SearchResponse.self , .search(keyword: keyword , itemCount: itemCount, pagingCount: pagingCount))
            .map{ [weak self] in
                guard let self = self else { return [] }
                self.pagingCountChecking(requestItemCount: $0.items?.count ?? 0)
                return $0.items ?? []
            }
    }
}
