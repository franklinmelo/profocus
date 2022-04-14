import Foundation

protocol CategoriesPresenting {
    var viewController: CategoriesDisplaying? { get set }
    
    func presentCategories()
}

final class CategoriesPresenter: CategoriesPresenting {
    weak var viewController: CategoriesDisplaying?
    
    func presentCategories() {
        viewController?.displayCategories()
    }
}
