
import UIKit

class SearchViewCoordinator: BaseCoordinator {
    
    
    
    override func start() {
        let viewModel = SearchViewModel()
        let viewController = SearchViewController(viewModel: viewModel)
        viewModel.coordinator = self
        let vc = UINavigationController(rootViewController: viewController)
        self.navigationController = vc
        
    }
    
    func repoDetailOpen(repo : Repo){
        let coordinator = RepoDetailViewCoordinator(navigationController: navigationController)
        coordinator.repo = repo
        coordinator.start()
    }
    
}
