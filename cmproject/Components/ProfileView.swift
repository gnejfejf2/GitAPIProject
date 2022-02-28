import SwiftUI
import UIKit
import Then
import SnapKit


class ProfileView: UIStackView {
    lazy var topInformationStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 10
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing:  8)

        $0.addArrangedSubview(profileImage)
        $0.addArrangedSubview(userNameLabel)
        $0.addArrangedSubview(followingLabel)
        $0.addArrangedSubview(follwerLabel)
    }
    
    
    
    var profileImage = UIImageView().then{
        $0.image = UIImage(named: "은하")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 24
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(48)
        }
    }
    
    var userNameLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textAlignment = .left
   
    }
    
    var followingLabel = KeyValueStackView(axis: .horizontal).then{
        $0.keyLabel.text = "팔로잉"
        $0.valueLabel.text = "0"
    }
    var follwerLabel = KeyValueStackView(axis: .horizontal).then{
        $0.keyLabel.text = "팔로워"
        $0.valueLabel.text = "0"
    }
    
    lazy var bottomInformationStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing:  8)
        $0.addArrangedSubview(privateRepoStackView)
        $0.addArrangedSubview(publicRepoStackView)
        $0.addArrangedSubview(starRepoStackView)
     
    }
    
    
    var privateRepoStackView = KeyValueStackView(axis: .vertical).then{
        $0.keyLabel.text = "Private Repo"
        $0.valueLabel.text = "0"
     
        
    }
    var publicRepoStackView = KeyValueStackView(axis: .vertical).then{
        $0.keyLabel.text = "Public Repo"
        $0.valueLabel.text = "0"
    }
    var starRepoStackView = KeyValueStackView(axis: .vertical).then{
        $0.keyLabel.text = "Stared Repo"
        $0.valueLabel.text = "0"
    
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        uiSetting()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        uiSetting()
    }
    
    
    func uiSetting(){
        self.axis = .vertical
       
        self.layer.cornerRadius = 8
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 5, bottom: 20, trailing:  5)
       
        self.addArrangedSubview(topInformationStackView)
        self.addArrangedSubview(bottomInformationStackView)
    }
    
}




@available(iOS 15.0, *)
struct ProfileView_Preview : PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let baseView = UIView()
            baseView.backgroundColor = .primaryColorReverse
            
            let view = ProfileView()
         
            
            baseView.addSubview(view)
            view.snp.makeConstraints { make in
                make.leading.top.equalTo(baseView.safeAreaLayoutGuide).offset(10)
                make.trailing.equalTo(baseView.safeAreaLayoutGuide).offset(-10)
            }
            
            return baseView
        }
        .frame(width: UIScreen.main.bounds.width , height: 600)
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}






