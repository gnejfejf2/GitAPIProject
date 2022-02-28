import UIKit

class ProfileViewCoordinator: BaseCoordinator {
    override func start() {
        
        
        let viewModel = ProfileViewModel()
        viewModel.coordinator = self
        let viewController = ProfileViewController(viewModel: viewModel)
        
        
        let vc = UINavigationController(rootViewController: viewController)
        self.navigationController = vc
    }
    
    func repoDetailOpen(repo : Repo){
        let coordinator = RepoDetailViewCoordinator(navigationController: navigationController)
        coordinator.repo = repo
        coordinator.start()
    }
    
}
