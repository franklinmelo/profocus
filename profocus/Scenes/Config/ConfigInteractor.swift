import Foundation

protocol ConfigInteracting: AnyObject {}

final class ConfigInteractor {
    private let presenter: ConfigPresenting?
    
    init(presenter: ConfigPresenting) {
        self.presenter = presenter
    }
}

extension ConfigInteractor: ConfigInteracting {}
