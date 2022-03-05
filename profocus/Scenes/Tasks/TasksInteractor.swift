import CoreData
import Foundation
import UIKit

protocol TasksInteracting: AnyObject {
    func getTasks()
    func deletTask(object: NSManagedObject)
    func handlerTaskData(task: NSManagedObject)
}

final class TasksInteractor: TasksInteracting {
    private var presenter: TasksPresenting?
    private var tasks: [NSManagedObject] = []
    
    init(presenter: TasksPresenting) {
        self.presenter = presenter
    }
    
    func getTasks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do {
            tasks = try managedContext.fetch(fetchRequest)
            presenter?.presentTasks(with: tasks)
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
    func deletTask(object: NSManagedObject) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(object)
        
        do {
            try managedContext.save()
            getTasks()
        } catch {
            print("Could not save. \(error)")
        }
    }
    
    func handlerTaskData(task: NSManagedObject) {
        presenter?.presentTaskData(with: task)
    }
}
