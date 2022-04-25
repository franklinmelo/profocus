import Foundation
import UIKit

protocol AnalyticsCoordinating {
    func openTaskDetails(with task: Task)
}

final class AnalyticsCoordinator: AnalyticsCoordinating {
    weak var viewController: UIViewController?
    
    func openTaskDetails(with task: Task) {
        let navigation = viewController?.navigationController
        let taskDeatilsViewController = TaskDetailsFactory().make(with: task)
        navigation?.pushViewController(taskDeatilsViewController, animated: true)
    }
}
