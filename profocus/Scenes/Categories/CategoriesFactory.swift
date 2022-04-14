import Foundation
import UIKit

struct CategoriesFactory {
    func make() -> UIViewController {
        var presenter: CategoriesPresenting = CategoriesPresenter()
        let interactor: CategoriesInterecting = CategoriesInteractor(presenter: presenter)
        let viewController = CategoriesViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}

