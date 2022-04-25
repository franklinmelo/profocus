import Foundation

protocol TaskDetailsInteracting {
    func fillTaskData()
}

final class TaskDetailsInteractor: TaskDetailsInteracting {
    private var presenter: TaskDetailsPresenting?
    private var task: Task
    
    init(presenter: TaskDetailsPresenting, task: Task) {
        self.presenter = presenter
        self.task = task
    }
    
    func fillTaskData() {
        presenter?.presentTaskData(task: task)
    }
}
