import Foundation
import UIKit

final class AnalyticsFactory {
    func make() -> UIViewController {
        let presenter = AnalyticsPresenter()
        let interactor = AnalyticsInteractor(presenter: presenter)
        let viewController = AnalyticsViewController(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
}
