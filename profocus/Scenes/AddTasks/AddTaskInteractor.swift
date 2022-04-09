import Foundation
import UIKit

protocol AddTaskInteracting {
    var catetories: [String] { get }
    
    func createTask(title: String, categorieIntex: Int)
}

final class AddTaskInteractor: AddTaskInteracting {
    var catetories: [String] = ["Reunião", "Task", "Programar"]
    private var presenter: AddTaskPresenting?
    
    init(presenter: AddTaskPresenting) {
        self.presenter = presenter
    }
    
    func createTask(title: String, categorieIntex: Int) {
        print("title: \(title)", "categorie: \(catetories[categorieIntex])")
    }
}
