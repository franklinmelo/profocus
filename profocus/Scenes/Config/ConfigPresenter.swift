import Foundation

protocol ConfigPresenting: AnyObject {}

final class ConfigPresenter {
    weak var viewController: ConfigDisplaying?
}

extension ConfigPresenter: ConfigPresenting {}
