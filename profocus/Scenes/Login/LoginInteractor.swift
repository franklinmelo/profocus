import AuthenticationServices
import Foundation
import CoreData

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
    
    private func saveUserData(userName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.userContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id = %@", "DEFAULT")
        
        do {
            let userData = try managedContext.fetch(fetchRequest)
            if !userData.isEmpty {
                return
            }
        } catch {
            print("Could not fetch. \(error)")
        }
        
        let user = User(context: managedContext)
        user.name = userName
        user.job = "Função"
        user.photo = URL(string: "")
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save. \(error)")
        }
    }
}

extension LoginInteractor: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            
            saveUserData(userName: "\(fullName?.givenName ?? "Usuário") \(fullName?.middleName ?? "ProFocus")")
            
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
