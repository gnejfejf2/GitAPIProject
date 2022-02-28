import UIKit

class AppCoordinator: BaseCoordinator {
    private let window : UIWindow
    
    


    init(window : UIWindow){
        self.window = window
        super.init(navigationController: UINavigationController())
    }
    
    override func start() {
        window.makeKeyAndVisible()
        tabBar()
    }
    
    private func tabBar() {
        removeChildCoordinators()
        
        
        let coordinator = TabBarCoordinator(navigationController: navigationController)
        start(coordinator: coordinator)
        
        window.rootViewController = coordinator.navigationController
    }
    
}
