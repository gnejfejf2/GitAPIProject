import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import RxRelay
import RxGesture
import Kingfisher

class RepoDetailViewController : SuperViewControllerSetting<RepoDetailViewModel> {
    
    lazy var mainInformationStackView = UIStackView().then{
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 18
        $0.alignment = .leading
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing:  16)
        $0.addArrangedSubview(userInformation)
        $0.addArrangedSubview(packageNameLabel)
        $0.addArrangedSubview(descriptionLabel)
       
        $0.addArrangedSubview(starStack)
        $0.addArrangedSubview(languageLebel)
        $0.addArrangedSubview(lisenceLebel)
        
        $0.addArrangedSubview(gitUrlLabel)
        
        $0.addArrangedSubview(starredButton)
    }
    
    var userInformation = ImageValueStackView(axis: .horizontal).then{
        
        $0.keyImage.layer.masksToBounds = true
        $0.keyImage.layer.cornerRadius = 10
        $0.keyImage.snp.remakeConstraints { make in
            make.width.height.equalTo(25)
        }
        $0.valueLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.valueLabel.textColor = .gray2
    }
    
    
  
    
    var packageNameLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        $0.textAlignment = .left
        $0.textColor = .primaryColor
    
    }
    
    var descriptionLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .primaryColor
    }
    
    var gitUrlLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .blue
    }
    
    
  
    
    var starStack = ImageValueStackView(axis: .horizontal).then{
        $0.spacing = 8
    }
    
    var languageLebel = KeyValueStackView(axis: .horizontal).then{
        $0.keyLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.keyLabel.text = "Language :"
        $0.valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
   
    var lisenceLebel = KeyValueStackView(axis: .horizontal).then{
        $0.keyLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.keyLabel.text = "Lisence :"
        $0.valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
   var starredButton = UIButton().then{
        $0.setTitle("Star Add", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.backgroundColor = .yellow
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.titleLabel?.textAlignment = .center
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    
    override func uiDrawing() {
        view.addSubview(mainInformationStackView)
  
        
        mainInformationStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        starredButton.snp.makeConstraints { make in
            make.leading.equalTo(mainInformationStackView).offset(16)
            make.trailing.equalTo(mainInformationStackView).offset(-16)
        }
        
    }
    
    override func viewModelBinding() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in }
            .asDriver{ _ in .empty()}
        
        
        let linkButtonTap = gitUrlLabel.rx.tapGesture()
            .when(.recognized)
            .asDriverOnErrorNever()
      
        
        
        let starAddAction = starredButton.rx.tap
            .asDriverOnErrorNever()
        
        let output = viewModel.transform(input: .init(viewWillAppear: viewWillAppear , linkButtonTap : linkButtonTap, starAddAction: starAddAction))
        
        
        
        
        output.repo
            .map{ $0.name }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output.repo
            .map{ $0.owner.avatarURL }
            .drive{ [weak self] url in
                guard let self = self else { return }
                self.userInformation.keyImage.kf.setImage(with: URL(string: url))
            }
            .disposed(by: disposeBag)
            
        
        output.repo
            .map{ $0.owner.login }
            .drive(userInformation.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.repo
            .map{ $0.name }
            .drive(packageNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.repo
            .map{ $0.welcomeDescription }
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.starred
     
            .map{
                if($0) {
                    return UIImage(systemName: "star.fill")!
                }else{
                    return UIImage(systemName: "star")!
                }
            }
            .drive(starStack.keyImage.rx.image)
            .disposed(by: disposeBag)
        
        output.repo
            .map{ $0.stargazersCount.roundedWithAbbreviations + " stars" }
            .drive(starStack.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.repo
            .map{ $0.language }
            .drive(languageLebel.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.repo
            .map{ $0.license?.name }
            .drive(lisenceLebel.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.repo
            .map{ $0.htmlURL }
            .drive(gitUrlLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.starred
            .drive{ [weak self] starred in
                guard let self = self else { return }
                if(starred){
                    self.starredButton.setTitle("Star Delete", for: .normal)
                    self.starredButton.backgroundColor = .primaryColorReverse
                    self.starredButton.layer.borderColor = UIColor.primaryColor.cgColor
                    self.starredButton.setTitleColor(.primaryColor, for: .normal)
                }else{
                    self.starredButton.setTitle("Star Add", for: .normal)
                    self.starredButton.backgroundColor = .yellow
                    self.starredButton.layer.borderColor = UIColor.clear.cgColor
                    self.starredButton.setTitleColor(.gray, for: .normal)
                }
            }.disposed(by: disposeBag)
  
        output.outputError
            .drive(onNext: { [ weak self] value in
                guard let self = self else { return }
                let alert = UIAlertController(title: "오류", message: value.localizedDescription , preferredStyle: .alert)
                let success = UIAlertAction(title: "확인", style: .default)
                alert.addAction(success)
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        
    }
}




