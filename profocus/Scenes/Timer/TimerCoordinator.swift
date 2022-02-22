import Foundation

protocol TimerCoodinating: AnyObject {
    func doSomeThing()
}

final class TimerCoodinator: TimerCoodinating {
    weak var viewController: TimerDisplaying?
    
    func doSomeThing() {}
}
