import UIKit
import SnapKit
import SwiftUI

class ImageValueStackView: UIStackView {

   
    var keyImage = UIImageView().then{
        $0.image = UIImage(systemName: "star")
        $0.tintColor = .systemYellow
        
        $0.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
    }
    
    
    
    var valueLabel = UILabel().then{
        $0.textAlignment = .left
        $0.textColor = .primaryColor
      
        $0.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
   
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        uiSetting()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        uiSetting()
    }
    
    convenience init(axis: NSLayoutConstraint.Axis) {
        self.init()
        self.axis = axis
        uiSetting()
    }
    
    
    func uiSetting() {
        
        self.distribution = .fill
        self.spacing = 8
        self.alignment = .center
        
        self.addArrangedSubview(keyImage)
        self.addArrangedSubview(valueLabel)
       
  
 
    }
}


@available(iOS 15.0, *)
struct ImageValueStackView_Preview : PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let baseView = UIView()
            baseView.backgroundColor = .primaryColorReverse
            
            let view = ImageValueStackView(axis: .horizontal)
    
            view.valueLabel.text = "0"
            
            
            baseView.addSubview(view)
            view.snp.makeConstraints { make in
                make.leading.top.equalTo(baseView.safeAreaLayoutGuide).offset(10)
            }
            
            return baseView
        }
      
        .frame(width: UIScreen.main.bounds.width , height: 600)
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}






