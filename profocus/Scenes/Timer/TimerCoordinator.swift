import Foundation
import UIKit

protocol TimerCoodinating: AnyObject {
    func doSomeThing()
}

final class TimerCoodinator: TimerCoodinating {
    weak var viewController: UIViewController?
    
    func doSomeThing() {}
}
