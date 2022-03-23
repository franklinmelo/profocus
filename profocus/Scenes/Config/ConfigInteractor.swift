import CoreData
import Foundation
import UIKit

protocol ConfigInteracting: AnyObject {
    func getConfigs()
    func handlerConfigTap(from type: ConfigType)
    func setUserName(with name: String)
    func setUserJob(with job: String)
}

final class ConfigInteractor {
    private let presenter: ConfigPresenting?
    private let configModels: [ConfigCellModel] = [.init(title: "Editar nome", type: .editName),
                                                   .init(title: "Editar função", type: .editJob),
                                                   .init(title: "Editar Photo", type: .editPhoto),
                                                   .init(title: "Link do repositório", type: .linkRepo),
                                                   .init(title: "Sair", type: .logout)]
    
    init(presenter: ConfigPresenting) {
        self.presenter = presenter
    }
    
    private func getUserInfo() -> (user: [User], managedContext: NSManagedObjectContext)? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.userContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do {
            let user = try managedContext.fetch(fetchRequest)
            return (user, managedContext)
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
        case .linkRepo:
            if let url = URL(string: "https://github.com/franklinmelo/profocus") {
                UIApplication.shared.open(url)
            }
        case .logout:
            UserDefaults.standard.removeObject(forKey: "userID")
            presenter?.presentLoginScreen()
        }
    }
    
    func setUserName(with name: String) {
        let args = getUserInfo()
        
        do {
            args?.user.last?.name = name
            try args?.managedContext.save()
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
    func setUserJob(with job: String) {
        let args = getUserInfo()
        
        do {
            args?.user.last?.job = job
            try args?.managedContext.save()
        } catch {
            print("Could not fetch. \(error)")
        }
    }
}
