import Foundation

protocol TimerPresenting: AnyObject {
    func presentTaskTitle(title: String)
    func presentStartTimer()
    func presentStopTimer()
    func presentTimer(with time: String)
}

final class TimerPresenter: TimerPresenting {
    weak var viewController: TimerDisplaying?
    private var coordinator: TimerCoordinating?
    
    init(coordinator: TimerCoordinating) {
        self.coordinator = coordinator
    }
    
    func presentTaskTitle(title: String) {
        viewController?.displayTaskTitle(with: title)
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
