//
//  LoginProtocol.swift
//  cmproject
//
//  Created by 강지윤 on 2022/02/22.
//

import Foundation

protocol LoginProtocol {
    
    func registerDialogNotification()
    func loginRecive(_ notification: Notification)
    func errorRecive(_ notification: Notification)
   
}
