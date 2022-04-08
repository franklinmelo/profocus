import Foundation

protocol AddTaskInteracting {}

final class AddTaskInteractor: AddTaskInteracting {
    private var presenter: AddTaskPresenting?
   
    
    init(presenter: AddTaskPresenting) {
        self.presenter = presenter
    }
}
