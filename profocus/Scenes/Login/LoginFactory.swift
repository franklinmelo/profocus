import Foundation
import UIKit

final class LoginFactory {
    func make() -> UIViewController {
        let coordinator = LoginCoordinator()
        let presenter = LoginPresenter(coordinator: coordinator)
        let interactor = LoginInteractor(presenter: presenter)
        let viewController = LoginViewController(interactor: interactor)
        
        presenter.viewController = viewController
        coordinator.viewController = viewController
        
        return viewController
    }
}
