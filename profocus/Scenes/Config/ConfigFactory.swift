import UIKit

final class ConfigFactory {
    func make() -> UIViewController {
        let coordinator = ConfigCoordinator()
        let presenter = ConfigPresenter(coordinator: coordinator)
        let interactor = ConfigInteractor(presenter: presenter)
        let viewController = ConfigViewController(interactor: interactor)
        
        presenter.viewController = viewController
        coordinator.viewController = viewController
        
        return viewController
    }
}
