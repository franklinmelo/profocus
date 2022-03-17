import UIKit

final class ConfigFactory {
    func make() -> UIViewController {
        let presenter = ConfigPresenter()
        let interactor = ConfigInteractor(presenter: presenter)
        let viewController = ConfigViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
