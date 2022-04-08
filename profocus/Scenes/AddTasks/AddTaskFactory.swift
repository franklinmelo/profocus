import Foundation
import UIKit

struct AddTaskFactory {
    static func make() -> UIViewController {
        let presenter = AddTaskPresenter()
        let interactor = AddTaskInteractor(presenter: presenter)
        let viewController = AddTaskViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
