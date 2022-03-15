import Foundation

protocol LoginPresenting: AnyObject {
    func presentLoginSuccess(with name:  PersonNameComponents?)
    func presentLoginError()
}

final class LoginPresenter: LoginPresenting {
    weak var viewController: LoginDisplaying?
    private var coordinator: LoginCoordinating?
    
    init(coordinator: LoginCoordinating) {
        self.coordinator = coordinator
    }
    
    func presentLoginSuccess(with name:  PersonNameComponents?) {
        coordinator?.openTimerView(with: name)
    }
    
    func presentLoginError() {
        viewController?.displayLoginError(title: "Ops!", message: "Ocorreu um erro ao tentar fazer login, por favor tente mais tarde")
    }
}
