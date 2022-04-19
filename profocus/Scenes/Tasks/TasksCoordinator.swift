import Foundation
import UIKit

protocol TasksCoordinating: AnyObject {
    func showTaskTimmer(task: Task)
}

final class TasksCoordinator: TasksCoordinating {
    weak var viewController: UIViewController?
    
    func showTaskTimmer(task: Task) {
        let navigation = viewController?.navigationController
        let timmerVC = UINavigationController(rootViewController: TimerFactory().make(task: task))
        navigation?.present(timmerVC, animated: true)
    }
}
