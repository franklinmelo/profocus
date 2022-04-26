import Foundation
import UIKit

final class TimerFactory {
    func make(task: Task) -> UIViewController {
        let presenter = TimerPresenter()
        let interactor = TimerInteractor(presenter: presenter, task: task)
        let viewController = TimerViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
