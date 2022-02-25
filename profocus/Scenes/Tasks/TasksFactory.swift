import Foundation
import UIKit

final class TasksFactory {
    func make() -> UIViewController {
        let presenter = TasksPresenter()
        let interactor = TasksInteractor(presenter: presenter)
        let viewContoroller = TasksViewController(interactor: interactor)
        
        presenter.viewController = viewContoroller
        
        return viewContoroller
    }
}
