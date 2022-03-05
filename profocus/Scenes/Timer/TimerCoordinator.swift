import Foundation
import UIKit

protocol TimerCoordinating: AnyObject {
    func doSomeThing()
}

final class TimerCoordinator: TimerCoordinating {
    weak var viewController: UIViewController?
    
    func doSomeThing() {}
}
