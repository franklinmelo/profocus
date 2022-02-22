import Foundation

protocol TimerInterecting: AnyObject {
    func doSomeThing()
}

final class TimerInteractor: TimerInterecting {
    weak var presenter: TimerPresenting?
    
    func doSomeThing() {
        print("hello")
    }
}
