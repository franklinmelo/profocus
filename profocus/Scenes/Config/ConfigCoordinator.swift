import Foundation
import UIKit

protocol ConfigCoordinating: AnyObject {
    func openLoginScreen()
    func openCategoriesScreen()
}

final class ConfigCoordinator {
    weak var viewController: UIViewController?
}

extension ConfigCoordinator: ConfigCoordinating {
    func openLoginScreen() {
        let loginController = LoginFactory().make()
        let navigation = viewController?.navigationController
        guard let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        scenes.windows.first?.rootViewController = loginController
        navigation?.popToRootViewController(animated: true)
    }
    
    func openCategoriesScreen() {
        let categoriesView = CategoriesFactory().make()
        let navigation = viewController?.navigationController
        
        navigation?.pushViewController(categoriesView, animated: true)
    }
}
