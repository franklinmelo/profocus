import Foundation

protocol TimerPresenting: AnyObject {
    func presentUserInfos(with model: UserModel)
    func presentStartTimer()
    func presentStopTimer()
    func presentTimer(with time: String)
    func presentStartAlert(title: String?, message: String?)
}

final class TimerPresenter: TimerPresenting {
    weak var viewController: TimerDisplaying?
    private var coordinator: TimerCoordinating?
    
    init(coordinator: TimerCoordinating) {
        self.coordinator = coordinator
    }
    
    func presentUserInfos(with model: UserModel) {
        viewController?.displayUserInfos(with: model)
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
    
    func presentStartAlert(title: String?, message: String?) {
        
    }
}
