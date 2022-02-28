import UIKit
import SnapKit
import SwiftUI

class KeyValueStackView: UIStackView {

   
    var keyLabel = UILabel().then{
        $0.textAlignment = .left
        $0.textColor = .primaryColor
        $0.font =  UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    
    
    var valueLabel = UILabel().then{
        $0.textAlignment = .left
        $0.textColor = .primaryColor
        $0.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
       
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
      
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
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
        
        self.addArrangedSubview(keyLabel)
        self.addArrangedSubview(valueLabel)
       
  
 
    }
}


@available(iOS 15.0, *)
struct KeyValue_Preview : PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let baseView = UIView()
            baseView.backgroundColor = .primaryColorReverse
            
            let view = KeyValueStackView()
            view.keyLabel.text = "팔로잉"
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






