import Foundation

protocol TasksPresenting: AnyObject {}

final class TasksPresenter: TasksPresenting {
    weak var viewController: TasksDisplaying?
}
