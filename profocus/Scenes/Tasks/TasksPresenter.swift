import CoreData
import Foundation

protocol TasksPresenting: AnyObject {
    func presentTasks(with task: [Task])
    func presentTaskData(with task: Task)
    func presentFilteredTasks(tasks: [Task])
}

final class TasksPresenter: TasksPresenting {
    weak var viewController: TasksDisplaying?
    private var coordinator: TasksCoordinating
    
    init(coordinator: TasksCoordinating) {
        self.coordinator = coordinator
    }
    
    func presentTasks(with task: [Task]) {
        viewController?.displayTasks(task: task)
    }
    
    func presentTaskData(with task: Task) {
        coordinator.showTaskTimmer(task: task)
    }
    
    func presentFilteredTasks(tasks: [Task]) {
        viewController?.displayFilteredTasks(tasks: tasks)
    }
}
