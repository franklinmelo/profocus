import Foundation

protocol ConfigInteracting: AnyObject {
    func getConfigs()
    func handlerConfigTap(from type: ConfigType)
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
}

extension ConfigInteractor: ConfigInteracting {
    func getConfigs() {
        presenter?.presentConfigs(with: configModels)
    }
    
    func handlerConfigTap(from type: ConfigType) {
        switch type {
        case .editName:
            print("editName")
        case .editJob:
            print("editJob")
        case .editPhoto:
            print("editPhoto")
        case .logout:
            UserDefaults.standard.removeObject(forKey: "userID")
            presenter?.presentLoginScreen()
        case .linkRepo:
            print("linkRepo")
        }
    }
}
