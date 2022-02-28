//
//  UserInfoModel.swift
//  cmproject
//
//  Created by 강지윤 on 2022/02/22.
//

import Foundation

struct UserInfoResponse : Codable {
    ///이름
    var login : String
    ///유저이메일
    var email : String?
    ///프로필사진 주소
    var avaterUrl : String
    
    var publicRepos : Int
    
    var privateRepos : Int
    
    var followers : Int
    
    var following : Int
    
    
    
    enum CodingKeys : String, CodingKey {
        case login
        case email
        case avaterUrl = "avatar_url"
        case publicRepos = "public_repos"
        case privateRepos = "owned_private_repos"
        case followers
        case following
    }
}
