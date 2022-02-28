//
//  AccessTokenResponse.swift
//  cmproject
//
//  Created by 강지윤 on 2022/02/22.
//

import Foundation


struct AccessTokenRequest : Codable {
    var client_id : String = LoginManager.shared.client_id
    var client_secret : String = LoginManager.shared.client_secret
    var code : String
}
