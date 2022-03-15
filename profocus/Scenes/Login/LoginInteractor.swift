import AuthenticationServices
import Foundation

protocol LoginInteracting: AnyObject {
    func handlerAppleAuth()
}

final class LoginInteractor: NSObject, LoginInteracting {
    private var presenter: LoginPresenting?
    init(presenter: LoginPresenting) {
        self.presenter = presenter
    }
    
    func handlerAppleAuth() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension LoginInteractor: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            
            let defaults = UserDefaults.standard
            defaults.set(userIdentifier, forKey: "userID")
            
            presenter?.presentLoginSuccess(with: fullName)
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        presenter?.presentLoginError()
    }
}
