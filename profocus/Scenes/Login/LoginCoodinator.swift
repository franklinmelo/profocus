import Foundation
import UIKit

protocol LoginCoordinating: AnyObject {
    func openTimerView(with name:  PersonNameComponents?)
}

final class LoginCoordinator: LoginCoordinating {
    weak var viewController: UIViewController?
    
    func openTimerView(with name:  PersonNameComponents?) {
        let mainViewController = TabBar()
        mainViewController.modalPresentationStyle = .fullScreen
        viewController?.present(mainViewController, animated: true)
    }
}
