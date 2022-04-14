import Foundation

protocol ConfigPresenting: AnyObject {
    func presentConfigs(with configModels: [ConfigCellModel])
    func presentLoginScreen()
    func presentEditNameAlert()
    func presentEditJobAlert()
    func presentUserData(with model: UserModel)
    func presentCategoriesScreen()
}

final class ConfigPresenter {
    weak var viewController: ConfigDisplaying?
    private let coordinator: ConfigCoordinating?
    
    init(coordinator: ConfigCoordinating) {
        self.coordinator = coordinator
    }
}

extension ConfigPresenter: ConfigPresenting {
    func presentConfigs(with configModels: [ConfigCellModel]) {
        viewController?.displayConfigs(with: configModels)
    }
    
    func presentLoginScreen() {
        coordinator?.openLoginScreen()
    }
    
    func presentEditNameAlert() {
        viewController?.displayEditNameAlert(title: "Editar nome", message: "Insira o novo nome que deseja")
    }
    
    func presentEditJobAlert() {
        viewController?.displayEditJobAlert(title: "Editar função", message: "Insira seu cargo ou função")
    }
    
    func presentUserData(with model: UserModel) {
        viewController?.displayUserData(with: model)
    }
    
    func presentCategoriesScreen() {
        coordinator?.openCategoriesScreen()
    }
}
