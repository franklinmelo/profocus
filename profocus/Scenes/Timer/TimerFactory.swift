import Foundation
import UIKit

final class TimerFactory {
    func make() -> UIViewController {
        let coodinator = TimerCoordinator()
        let presenter = TimerPresenter(coordinator: coodinator)
        let interactor = TimerInteractor(presenter: presenter)
        let viewController = TimerViewController(interactor: interactor)
        
        presenter.viewController = viewController
        coodinator.viewController = viewController
        
        return viewController
    }
}
