import Foundation

protocol TaskDetailsPresenting {
    func presentTaskData(task: Task)
}

final class TaskDetailsPresenter: TaskDetailsPresenting {
    weak var viewController: TaskDetailsDisplay?
    
    func presentTaskData(task: Task) {
        viewController?.displayTaskData(task: task)
    }
}
