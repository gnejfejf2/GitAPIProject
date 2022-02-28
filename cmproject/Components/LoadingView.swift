//
//  LoadingView.swift
//  cmproject
//
//  Created by 강지윤 on 2022/02/25.
//

import Foundation
import SwiftUI
import UIKit
import Then
import SnapKit


class LoadingView : UIView {
    var activityIndicator = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        uiSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        uiSetting()
    }
    
    
    func uiSetting(){
        self.backgroundColor = .black.withAlphaComponent(0.3)
        self.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}










