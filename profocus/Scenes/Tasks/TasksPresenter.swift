import CoreData
import Foundation

protocol TasksPresenting: AnyObject {
    func presentTasks(with task: [NSManagedObject])
    func presentTaskData(with task: NSManagedObject)
}

final class TasksPresenter: TasksPresenting {
    weak var viewController: TasksDisplaying?
    private var coordinator: TasksCoordinating
    
    init(coordinator: TasksCoordinating) {
        self.coordinator = coordinator
    }
    
    func presentTasks(with task: [NSManagedObject]) {
        viewController?.displayTasks(task: task)
    }
    
    func presentTaskData(with task: NSManagedObject) {
        let taskName = task.value(forKey: "name") as? String ?? ""
        let taskMin = task.value(forKey: "timeMin") as? Int ?? 0
        let taskSec = task.value(forKey: "timeSec") as? Int ?? 0
        let taskMessage = "O tempo de foco dessa tarefa foi de \(taskMin)min e \(taskSec)sec"
        coordinator.showTaskInfo(title: taskName, message: taskMessage)
    }
}
