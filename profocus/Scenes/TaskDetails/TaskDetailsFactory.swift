import Foundation
import UIKit

struct TaskDetailsFactory {
    func make(with task: Task) -> UIViewController {
        let presenter = TaskDetailsPresenter()
        let interactor: TaskDetailsInteracting = TaskDetailsInteractor(presenter: presenter, task: task)
        let viewController = TaskDetailsViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
