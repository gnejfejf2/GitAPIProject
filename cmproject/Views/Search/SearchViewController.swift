import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import RxRelay
import RxGesture


class SearchViewController: SuperViewControllerSetting<SearchViewModel> {
    
    lazy var searchBar = UISearchBar().then{
        $0.placeholder = "검색어를 입력해주세요."
        $0.searchBarStyle = .minimal
        
        $0.searchTextField.layer.borderColor = UIColor.gray.cgColor
        $0.searchTextField.layer.cornerRadius = 10
        $0.searchTextField.layer.borderWidth = 1
        $0.searchTextField.largeContentImage?.withTintColor(.gray) // 왼쪽 돋보기 모양 커스텀
        $0.searchTextField.borderStyle = .none // 기본으로 있는 회색배경 없애줌
        $0.searchTextField.leftView?.tintColor = .gray
        

    }
    
    
    let repoCollectionView : UICollectionView = {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(400)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = itemSize
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: compositionalLayout)
        collectionView.indicatorStyle = .white
        collectionView.register(RepoCollectionViewCell.self, forCellWithReuseIdentifier: RepoCollectionViewCell.id)
        return collectionView
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarTitleSetting("GitHub")
        
       
    }
    
   
    override func uiDrawing() {
        view.addSubview(searchBar)
        view.addSubview(repoCollectionView)
        
        
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        repoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    override func uiSetting(){
        repoCollectionView.delegate = self
    }
    
    override func viewModelBinding() {
        
        let searchKeyword = searchBar.rx.text
            .orEmpty
            .asDriverOnErrorNever()
        
        let searchAction = searchBar.searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .map{ [weak self] event -> Void in
                guard let self = self else { return }
                self.searchBar.resignFirstResponder()
            }
            .asDriverOnErrorNever()
        
        let scrollAction = repoCollectionView.rx
            .reachedBottom(offset: 0)
            .filter{ [weak self] in
                guard let self = self else { return false }
                return self.viewModel.scrollPagingCall == true
            }
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .asDriverOnErrorNever()
        
        let repositoryTapAction = repoCollectionView.rx
            .modelSelected(Repo.self)
            .asDriver()
        
        
        let input = SearchViewModel.Input(searchKeyword: searchKeyword, searchAction: searchAction , bottomScrollTriger: scrollAction , repositoryTapAction : repositoryTapAction)
        
        let output = viewModel.transform(input: input)
        
        
        
        output.searchKeyword
            .drive{ [weak self] _ in
                guard let self = self else { return }
                return self.repoCollectionView.setContentOffset(.zero, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.starredRepos
            .drive(repoCollectionView.rx.items(cellIdentifier: RepoCollectionViewCell.id, cellType: RepoCollectionViewCell.self)){(index , element , cell) in
                cell.uiSetting(getRepo: element)
            }
            .disposed(by: disposeBag)
     
        output.loading
            .drive{ [weak self] loading in
                guard let self = self else { return }
                return self.loadingViewSetting(loading: loading)
            }
            .disposed(by: disposeBag)
        
    }
    
    
}


extension SearchViewController : UICollectionViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
