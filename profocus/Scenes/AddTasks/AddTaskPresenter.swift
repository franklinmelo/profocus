import Foundation

protocol AddTaskPresenting {
    func presentShowKeyboard()
    func presentHideKeyboard()
}

final class AddTaskPresenter: AddTaskPresenting {
    weak var viewController: AddTaskDisplaing?
    
    func presentShowKeyboard() {
        
    }
    
    func presentHideKeyboard() {
        
    }
}
