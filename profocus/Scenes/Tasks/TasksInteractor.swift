import CoreData
import Foundation
import UIKit

protocol TasksInteracting: AnyObject {
    func getTasks()
    func deletTask(object: NSManagedObject)
    func handlerTaskData(task: Task)
    func filterTasks(for name: String)
}

final class TasksInteractor: TasksInteracting {
    private var presenter: TasksPresenting?
    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []
    
    init(presenter: TasksPresenting) {
        self.presenter = presenter
    }
    
    func getTasks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.taskContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            tasks = try managedContext.fetch(fetchRequest)
            presenter?.presentTasks(with: tasks)
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
    func deletTask(object: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.taskContainer.viewContext
        
        managedContext.delete(object)
        
        do {
            try managedContext.save()
            getTasks()
        } catch {
            print("Could not save. \(error)")
        }
    }
    
    func handlerTaskData(task: Task) {
        presenter?.presentTaskData(with: task)
    }
    
    func filterTasks(for name: String) {
        filteredTasks = tasks.filter { (task: Task) -> Bool in
            let taskName = task.value(forKey: "name") as? String ?? ""
            return taskName.lowercased().contains(name.lowercased())
        }
        
        presenter?.presentFilteredTasks(tasks: filteredTasks)
    }
}
