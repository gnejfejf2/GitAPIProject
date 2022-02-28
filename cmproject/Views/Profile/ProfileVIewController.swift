import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import RxRelay
import RxGesture


class ProfileViewController : SuperViewControllerSetting<ProfileViewModel> {
    
    var profileView = ProfileView()
    
    
    var loginButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil).then{
        $0.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: 14, weight: .bold)], for: .normal)
    }
    
    
    lazy var loginView = UIView().then{
        $0.backgroundColor = .primaryColorReverse
        $0.addSubview(loginStackView)
    }
    
    lazy var loginStackView = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fill
        $0.alignment = .center
        $0.addArrangedSubview(loginLabel)
        $0.addArrangedSubview(centerLoginButton)
    }
    
    
    let refreshControler = UIRefreshControl().then{
        $0.tintColor = .primaryColor
        $0.attributedTitle = NSAttributedString(string: "Reload")
    }
    
    lazy var repoCollectionView : UICollectionView = {
        
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
        collectionView.refreshControl = refreshControler
        return collectionView
    }()
    
    
    var loginLabel = UILabel().then{
        $0.text = "로그인이 필요합니다"
        $0.textColor = .primaryColor
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    var centerLoginButton = UIButton().then{
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 8
        $0.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
    }
   

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarTitleSetting("GitHub")
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = loginButton
      
    }
    
    
    override func uiDrawing() {
        view.addSubview(profileView)
        view.addSubview(repoCollectionView)
        view.addSubview(loginView)
        
        
        
        profileView.snp.makeConstraints { make in
            make.leading.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
        
        loginView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        loginStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        repoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.trailing.leading.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        
    }
    
    override func viewModelBinding() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in }
            .asDriver{ _ in .empty()}
        
        let loginAction2 =   loginButton.rx.tap.asDriverOnErrorNever()
          
        let loginAction1 =  centerLoginButton.rx.tap.asDriverOnErrorNever()
            
        let masterAction = Driver.merge(loginAction1,loginAction2)
        
        
        let loginUpdate =  NotificationCenter.default.rx.notification(.LOGIN).asDriverOnErrorNever()
        
        let loginError =   NotificationCenter.default.rx.notification(.LOGINERROR)
            .map{ $0.userInfo?["Error"] as? String  }
            .compactMap{ $0 }
            .asDriverOnErrorNever()
        
        let repositoryTapAction = repoCollectionView.rx
            .modelSelected(Repo.self)
            .asDriver()
        
        let pullToScroll = repoCollectionView.refreshControl!.rx.controlEvent(.valueChanged)
            .asDriverOnErrorNever()
    
        let scrollAction = repoCollectionView.rx.reachedBottom(offset: 0)
            .filter{ [weak self] in
                guard let self = self else { return false }
                return self.viewModel.scrollPagingCall == true
            }
            .throttle(.seconds(3), latest: false, scheduler: MainScheduler.instance)
            .asDriverOnErrorNever()
        
        let input = ProfileViewModel.Input(viewWillAppear : viewWillAppear ,loginAction: masterAction, loginUpdate: loginUpdate, loginError: loginError, repositoryTapAction: repositoryTapAction , pullToScroll: pullToScroll, bottomScrollTriger: scrollAction)
        
        let output = viewModel.transform(input: input)
        
        output.starredRepos
            .drive(repoCollectionView.rx.items(cellIdentifier: RepoCollectionViewCell.id, cellType: RepoCollectionViewCell.self)){(index , element , cell) in
                cell.uiSetting(getRepo: element , starred: true)
            }
            .disposed(by: disposeBag)
        output.starredRepos
            .drive{ [weak self] _ in
                guard let self = self else { return }
                self.repoCollectionView.refreshControl?.endRefreshing()
            }.disposed(by: disposeBag)
        
        
        output.userInfo
            .map{ $0 != nil }
            .drive(loginView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.userInfo
            .map{ $0 != nil ? "로그아웃" : "로그인" }
            .drive(loginButton.rx.title)
            .disposed(by: disposeBag)
        
        
        
        
        output.outputError
            .drive(onNext: { [ weak self] value in
                guard let self = self else { return }
                let alert = UIAlertController(title: "오류", message: value.localizedDescription , preferredStyle: .alert)
                let success = UIAlertAction(title: "확인", style: .default)
                alert.addAction(success)
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        output.userInfo
            .map{ item -> String? in
                guard let value = item?.login else { return nil }
                return String(value)
            }
            .drive(profileView.userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        output.userInfo
            .map{ item -> String? in
                guard let value = item?.following else { return nil }
                return String(value)
            }
            .drive(profileView.followingLabel.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.userInfo
            .map{ item -> String? in
                guard let value = item?.followers else { return nil }
                return String(value)
            }
            .drive(profileView.follwerLabel.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.userInfo
            .map{ item -> String? in
                guard let value = item?.publicRepos else { return nil }
                return String(value)
            }
            .drive(profileView.publicRepoStackView.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.userInfo
            .map{ item -> String? in
                guard let value = item?.privateRepos else { return nil }
                return String(value)
            }
            .drive(profileView.privateRepoStackView.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.starredRepos
            .map{ item -> String? in
                String(item.count)
            }
            .drive(profileView.starRepoStackView.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.loading
            .drive{ [weak self] loading in
                guard let self = self else { return }
                self.loadingViewSetting(loading: loading)
            }
            .disposed(by: disposeBag)
    }
}




