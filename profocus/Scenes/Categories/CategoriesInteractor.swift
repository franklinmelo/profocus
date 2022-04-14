import Foundation
import UIKit
import CoreData

protocol CategoriesInterecting {
    var categories: [Categorie] { get }
    var filteredCategories: [Categorie] { get }

    func getCategories()
    func addCategorie(with title: String)
    func deleteCategorie(categorie: Categorie)
    func filterCategories(for title: String)
}

final class CategoriesInteractor: CategoriesInterecting {
    private let presenter: CategoriesPresenting
    internal var categories: [Categorie] = []
    internal var filteredCategories: [Categorie] = []
    
    init(presenter: CategoriesPresenting) {
        self.presenter = presenter
    }
    
    func getCategories() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.taskContainer.viewContext
        let fetchRequest = NSFetchRequest<Categorie>(entityName: "Categorie")
        
        do {
            categories = try managedContext.fetch(fetchRequest)
            presenter.presentCategories()
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
    func addCategorie(with title: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.taskContainer.viewContext
        
        let categorie = Categorie(context: managedContext)
        categorie.name = title
        
        do {
            try managedContext.save()
            getCategories()
        } catch {
            print("Could not save. \(error)")
        }
    }
    
    func deleteCategorie(categorie: Categorie) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.taskContainer.viewContext
        
        managedContext.delete(categorie)
        
        do {
            try managedContext.save()
            getCategories()
        } catch {
            print("Could not Delete. \(error)")
        }
    }
    
    func filterCategories(for title: String) {
        filteredCategories = categories.filter({ (categorie: Categorie) -> Bool in
            let name = categorie.name ?? ""
            return name.lowercased().contains(title.lowercased())
        })
        presenter.presentCategories()
    }
}
