import Foundation

protocol TimerPresenting: AnyObject {
    func presentTaskInfo(with task: Task)
    func presentStartTimer()
    func presentStopTimer()
    func presentTimer(with time: String)
}

final class TimerPresenter: TimerPresenting {
    weak var viewController: TimerDisplaying?
    
    func presentTaskInfo(with task: Task) {
        viewController?.displayTaskInfos(with: task)
    }
    
    func presentStartTimer() {
        viewController?.displayStartTimer()
    }
    
    func presentStopTimer() {
        viewController?.displayStopTimer()
    }
    
    func presentTimer(with time: String) {
        viewController?.displayUpdateTimer(with: time)
    }
}
