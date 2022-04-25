import Foundation
import UIKit

final class AnalyticsFactory {
    func make() -> UIViewController {
        let coodinator = AnalyticsCoordinator()
        let presenter = AnalyticsPresenter(coordinator: coodinator)
        let interactor = AnalyticsInteractor(presenter: presenter)
        let viewController = AnalyticsViewController(interactor: interactor)
        
        presenter.viewController = viewController
        coodinator.viewController = viewController
        
        return viewController
    }
}
