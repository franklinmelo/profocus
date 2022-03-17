import Foundation
import UIKit

protocol ConfigDisplaying: AnyObject {}

final class ConfigViewController: UIViewController {
    private let interactor: ConfigInteracting?
    
    init(interactor: ConfigInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ConfigViewController: ConfigDisplaying {}
