import CoreData
import Foundation
import UIKit

protocol ConfigInteracting: AnyObject {
    func getConfigs()
    func handlerConfigTap(from type: ConfigType)
    func setUserName(with name: String)
    func setUserJob(with job: String)
    func getUserData()
}

final class ConfigInteractor {
    private let presenter: ConfigPresenting?
    private let configModels: [ConfigCellModel] = [.init(title: "Editar nome", type: .editName),
                                                   .init(title: "Editar função", type: .editJob),
                                                   .init(title: "Editar foto", type: .editPhoto),
                                                   .init(title: "Adicionar categorias", type: .editCategories),
                                                   .init(title: "Sair", type: .logout)]
    
    init(presenter: ConfigPresenting) {
        self.presenter = presenter
    }
    
    private func getUserInfo() -> (user: User?, managedContext: NSManagedObjectContext)? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.userContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id = %@", "DEFAULT")
        
        do {
            let user = try managedContext.fetch(fetchRequest)
            return (user.first, managedContext)
        } catch {
            print("Could not fetch. \(error)")
            return nil
        }
    }
}

extension ConfigInteractor: ConfigInteracting {
    func getConfigs() {
        presenter?.presentConfigs(with: configModels)
    }
    
    func handlerConfigTap(from type: ConfigType) {
        switch type {
        case .editName:
            presenter?.presentEditNameAlert()
        case .editJob:
            presenter?.presentEditJobAlert()
        case .editPhoto:
            print("editPhoto")
        case .editCategories:
            presenter?.presentCategoriesScreen()
        case .logout:
            UserDefaults.standard.removeObject(forKey: "userID")
            presenter?.presentLoginScreen()
        }
    }
    
    func setUserName(with name: String) {
        let args = getUserInfo()
        
        do {
            args?.user?.name = name
            try args?.managedContext.save()
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
    func setUserJob(with job: String) {
        let args = getUserInfo()
        
        do {
            args?.user?.job = job
            try args?.managedContext.save()
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
    func getUserData() {
        let user = getUserInfo()?.user
        guard let userName = user?.name, let userJob = user?.job else { return }
        presenter?.presentUserData(with: .init(userName: userName,
                                               userJob: userJob))
    }
}
