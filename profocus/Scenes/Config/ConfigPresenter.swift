import Foundation

protocol ConfigPresenting: AnyObject {
    func presentConfigs(with configModels: [ConfigCellModel])
    func presentLoginScreen()
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
}
