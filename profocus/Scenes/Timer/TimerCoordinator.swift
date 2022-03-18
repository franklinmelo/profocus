import Foundation
import UIKit

protocol TimerCoordinating: AnyObject {
    func openSettingsScreen()
}

final class TimerCoordinator: TimerCoordinating {
    weak var viewController: UIViewController?
    
    func openSettingsScreen() {
        let settingsViewController = ConfigFactory().make()
        let navigation = viewController?.navigationController
        
        navigation?.pushViewController(settingsViewController, animated: true)
    }
}
