import UIKit

enum TabbarFlow {
    
    case search
    case profile
}

class TabBarCoordinator: BaseCoordinator {
    
    private let searchViewCoordinator =  SearchViewCoordinator(navigationController: UINavigationController())
    private let profileViewCoordinator = ProfileViewCoordinator(navigationController: UINavigationController())
    private let tabbarController = UITabBarController()
    
    override func start() {
        start(coordinator: searchViewCoordinator)
        start(coordinator: profileViewCoordinator)
        
        
        searchViewCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "2.circle"), tag: 0)
        profileViewCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "3.circle"), tag: 1)
        
        //        self.tabbarController.viewControllers = [beerListCoordinator.navigationController, searchBeerCoordinator.navigationController, randomBeerCoordinator.navigationController]
        
        
        tabbarController.viewControllers = [ searchViewCoordinator.navigationController , profileViewCoordinator.navigationController]
        
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabbarController, animated: false)
    }
    
    func moveTo(flow: TabbarFlow) {
        switch flow {
        case .search:
            tabbarController.selectedIndex = 0
        case .profile:
            tabbarController.selectedIndex = 1
        }
    }
}

