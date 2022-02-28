//
//  Encodeable_Extension.swift
//  cmproject
//
//  Created by 강지윤 on 2022/02/24.
//

import Foundation
extension Encodable {
    var toDictionary : [String: Any] {
        guard let object = try? JSONEncoder().encode(self) else { return [:] }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return [:] }
        return dictionary
    }
}

