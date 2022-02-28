//
//  SceneDelegate.swift
//  cmproject
//
//  Created by 강지윤 on 2022/02/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var appMainCoordinator : AppCoordinator?
    
    let networkMGR : NetworkingAPI = NetworkingAPI.shared
    
    let userMGR : UserDefaultsManager = UserDefaultsManager.shared
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        
        appMainCoordinator = AppCoordinator(window: self.window!)
        appMainCoordinator?.start()
        
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            self.deepLinkAction(url: context.url.absoluteURL)
        }
    }
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
    
    func deepLinkAction(url : URL){
        guard let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = urlComponents.host
        else {
            return
        }
        guard urlComponents.scheme == "cmproject" else {
            return
        }
        
        switch host {
        case "login":
            let code = url.absoluteString.components(separatedBy: "code=").last ?? ""
            NetworkingAPI.shared.provider
                .request(.loginAccesstoken(code: code)){ [weak self] response in
                    switch response {
                    case .success(let result):
                        do {
                            let data = try JSONDecoder().decode(AccessTokenResponse.self, from: result.data)
                            guard let self = self else { return }
                            self.userMGR.accessToken = data.access_token
                            NotificationCenter.default.post(name: NSNotification.Name(NSNotificationName.LOGIN.rawValue), object: self, userInfo: nil)
                        } catch(let err) {
                            let loginError : [String: String] = [
                                "Error": err.localizedDescription
                            ]
                            NotificationCenter.default.post(name: NSNotification.Name(NSNotificationName.LOGINERROR.rawValue), object: self, userInfo: loginError)
                        }
                    case .failure(let err):
                        let loginError : [String: String] = [
                            "Error": err.localizedDescription
                        ]
                        NotificationCenter.default.post(name: NSNotification.Name(NSNotificationName.LOGINERROR.rawValue), object: self, userInfo: loginError)
                    }
                }
        default:
            break
        }
    }
    
}

