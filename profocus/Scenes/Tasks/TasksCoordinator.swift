import Foundation
import UIKit

protocol TasksCoordinating: AnyObject {
    func showTaskTimmer(task: Task)
}

final class TasksCoordinator: TasksCoordinating {
    weak var viewController: UIViewController?
    
    func showTaskTimmer(task: Task) {
        let navigation = viewController?.navigationController
        let timmerVC = TimerFactory().make(task: task)
        navigation?.pushViewController(timmerVC, animated: true)
    }
}
