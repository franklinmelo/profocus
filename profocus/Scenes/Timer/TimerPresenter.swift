import Foundation

protocol TimerPresenting: AnyObject {
    func doSomeThing()
}

final class TimerPresenter: TimerPresenting {
    weak var viewController: TimerDisplaying?
    
    func doSomeThing() {}
}
