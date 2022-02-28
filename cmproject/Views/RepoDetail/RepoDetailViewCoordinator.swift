import UIKit

class RepoDetailViewCoordinator : BaseCoordinator {
    
    var repo : Repo?
    
    override func start() {
        guard let repo = repo else { return }

        
        let viewModel = RepoDetailViewModel(networkAPI: NetworkingAPI.shared , repo: repo)
        viewModel.coordinator = self
        let viewController = RepoDetailViewController(viewModel: viewModel)
        
        
      
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func openSafari(url : String){
        if let url = URL(string : url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
}
