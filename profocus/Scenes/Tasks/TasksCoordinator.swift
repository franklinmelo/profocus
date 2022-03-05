import Foundation
import UIKit

protocol TasksCoordinating: AnyObject {
    func showTaskInfo(title: String, message: String)
}

final class TasksCoordinator: TasksCoordinating {
    weak var viewController: UIViewController?
    
    func showTaskInfo(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        viewController?.present(alert, animated: true)
    }
}
