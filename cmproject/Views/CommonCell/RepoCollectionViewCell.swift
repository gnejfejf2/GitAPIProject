//
//  CategoryCollectionViewCell.swift
//  rxSwiftApp
//
//  Created by Hwik on 2022/01/19.
//

import UIKit
import SnapKit
import Then
import SwiftUI
import Kingfisher

class RepoCollectionViewCell: SuperCollectionViewCellSetting {
   
    static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
    
    
    lazy var mainInformationStackView = UIStackView().then{
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 6
        $0.alignment = .leading
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing:  16)
        $0.addArrangedSubview(userInformation)
      
        
        $0.addArrangedSubview(packageNameLabel)
        $0.addArrangedSubview(descriptionLabel)
        $0.addArrangedSubview(subInformationStackView)
    }
    
    var userInformation = ImageValueStackView(axis: .horizontal).then{
        
        $0.keyImage.layer.masksToBounds = true
        $0.keyImage.layer.cornerRadius = 10
        $0.keyImage.snp.remakeConstraints { make in
            make.width.height.equalTo(20)
        }
        $0.valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
      
        $0.valueLabel.textColor = .gray2

    }
    
    
  
    
    var packageNameLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .left
        $0.textColor = .primaryColor
    }
    
    var descriptionLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .primaryColor

    }
    
    lazy var subInformationStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 8
        $0.alignment = .leading
        $0.addArrangedSubview(starStack)
        $0.addArrangedSubview(languageLebel)
        $0.addArrangedSubview(lisenceLebel)
    }
    
    var starStack = ImageValueStackView(axis: .horizontal).then{
        $0.spacing = 4
    }
    var languageLebel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
   
    var lisenceLebel = UILabel().then{

        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
    }
    
    var repo : Repo?
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }

    

    override func setupUI() {
        self.addSubview(mainInformationStackView)
  
        mainInformationStackView.snp.makeConstraints { make in
  
            make.top.leading.bottom.trailing.equalToSuperview()
           
        }
    }
    
    
    
    func uiSetting(getRepo : Repo , starred : Bool = false){
        self.repo = getRepo
        guard let repo = repo else { return }
   
        userInformation.keyImage.kf.setImage(with: URL(string: repo.owner.avatarURL), placeholder: UIImage(named: "은하"))
        userInformation.valueLabel.text = repo.owner.login
        packageNameLabel.text = repo.name
        descriptionLabel.text = repo.welcomeDescription
        languageLebel.text = repo.language
        starStack.valueLabel.text = repo.stargazersCount.roundedWithAbbreviations
        lisenceLebel.text = repo.license?.name
//        i
        if(starred){
            starStack.keyImage.image = UIImage(systemName: "star.fill")
        }
        
    }
    

    
 
}


@available(iOS 15.0, *)
struct RepoCollectionViewCell_Preview : PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let baseView = UIView()
           
            let view = RepoCollectionViewCell()
           
            view.uiSetting(getRepo: Repo(id: 1, name: "Swift", owner: Owner(login: "Apple", avatarURL: "https://avatars.githubusercontent.com/u/59394156?v=4"), htmlURL: "", welcomeDescription: "헤위~", fork: false, updatedAt: "", stargazersCount: 300, watchersCount: 300, language: "Swift", license: License(key: "Mit", name: "", spdxID: "", url: ""), topics: [], visibility: "", forks: 0, openIssues: 0, watchers: 0))
            
            baseView.addSubview(view.mainInformationStackView)
            view.mainInformationStackView.snp.makeConstraints { make in
                make.top.trailing.leading.equalToSuperview()
            }
            
            return baseView
        }
      
        .frame(width: UIScreen.main.bounds.width , height: 600)
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}





