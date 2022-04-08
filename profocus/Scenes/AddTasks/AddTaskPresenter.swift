import Foundation

protocol AddTaskPresenting {}

final class AddTaskPresenter: AddTaskPresenting {
    weak var viewController: AddTaskDisplaing?
}
