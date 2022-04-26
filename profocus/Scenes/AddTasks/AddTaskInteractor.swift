import CoreData
import Foundation
import UIKit

protocol AddTaskInteracting {
    var categories: [Categorie] { get }
    
    func createTask(title: String, categorieIntex: Int)
    func getCategories()
}

final class AddTaskInteractor: AddTaskInteracting {
    var categories: [Categorie] = []
    private var presenter: AddTaskPresenting?
    
    init(presenter: AddTaskPresenting) {
        self.presenter = presenter
    }
    
    func getCategories() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.taskContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Categorie>(entityName: "Categorie")
        
        do {
            categories = try managedContext.fetch(fetchRequest)
            if categories.isEmpty {
                createDefaultCategorie()
            }
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
    private func createDefaultCategorie() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.taskContainer.viewContext

        let categorie = Categorie(context: managedContext)
        categorie.name = "Reunião"

        do {
            try managedContext.save()
            getCategories()
        } catch {
            print("Could not save. \(error)")
        }
    }
    
    func createTask(title: String, categorieIntex: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.taskContainer.viewContext

        let task = Task(context: managedContext)
        task.id = UUID.init()
        task.name = title
        task.createdAt = Date().timeIntervalSince1970
        task.categorie = categories[categorieIntex]
        task.timeMin = Int16(0)
        task.timeSec = Int16(0)
        task.completed = false

        do {
            try managedContext.save()
        } catch {
            print("Could not save. \(error)")
        }
    }
}
