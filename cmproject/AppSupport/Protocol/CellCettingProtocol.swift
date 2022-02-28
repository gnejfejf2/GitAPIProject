import Foundation
import UIKit

protocol CellCettingProtocol {
   func setupUI()
}




class SuperCollectionViewCellSetting : UICollectionViewCell , CellCettingProtocol{
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }

   
    func setupUI() {
        
    }
    
}


