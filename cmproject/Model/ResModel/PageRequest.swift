//
//  PageResponse.swift
//  cmproject
//
//  Created by 강지윤 on 2022/02/23.
//


struct PageRequest : Codable {
    
    var perPage : Int = 30
    var page : Int
    
    
    enum CodingKeys : String, CodingKey {
        case perPage = "per_page"
        case page
       
    }
}
