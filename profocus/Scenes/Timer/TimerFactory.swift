import Foundation
import UIKit

final class TimerFactory {
    func make() -> UIViewController {
        let interactor = TimerInteractor()
        let presenter = TimerPresenter()
        let viewController = TimerViewController(interactor: interactor)
        let coodinator = TimerCoodinator()
        
        interactor.presenter = presenter
        presenter.viewController = viewController
        coodinator.viewController = viewController
        
        return viewController
    }
}
