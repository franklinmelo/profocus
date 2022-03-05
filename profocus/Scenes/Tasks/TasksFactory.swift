import Foundation
import UIKit

final class TasksFactory {
    func make() -> UIViewController {
        let coordinator = TasksCoordinator()
        let presenter = TasksPresenter(coordinator: coordinator)
        let interactor = TasksInteractor(presenter: presenter)
        let viewContoroller = TasksViewController(interactor: interactor)
        
        presenter.viewController = viewContoroller
        coordinator.viewController = viewContoroller
        
        return viewContoroller
    }
}
