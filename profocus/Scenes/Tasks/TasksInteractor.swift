import Foundation

protocol TasksInteracting: AnyObject {}

final class TasksInteractor: TasksInteracting {
    private var presenter: TasksPresenting?
    
    init(presenter: TasksPresenting) {
        self.presenter = presenter
    }
}
