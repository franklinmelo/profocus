import AuthenticationServices
import Foundation
import UIKit

protocol LoginDisplaying: AnyObject {
    func displayLoginError(title: String, message: String)
}

final class LoginViewController: UIViewController {
    private var interactor: LoginInteracting?
    private lazy var containerView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .cyan.withAlphaComponent(0.75)
        return $0
    }(UIView())
    
    private lazy var titleLable: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .preferredFont(forTextStyle: .largeTitle)
        $0.text = "ProFocus"
        return $0
    }(UILabel())
    
    private lazy var subTitleLable: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .boldSystemFont(ofSize: 17)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "Faça login com sua conta Apple no aplicativo para melhorar seu foco e produtividade"
        return $0
    }(UILabel())
    
    private lazy var authButton: ASAuthorizationAppleIDButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(handleAuthorizationApple), for: .touchUpInside)
        return $0
    }(ASAuthorizationAppleIDButton(type: .signIn, style: .white))
    
    init(interactor: LoginInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureViews()
    }
    
    private func setupViews() {
        containerView.addSubview(titleLable)
        containerView.addSubview(subTitleLable)
        containerView.addSubview(authButton)
        
        view.addSubview(containerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLable.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLable.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 16),
            subTitleLable.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subTitleLable.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            subTitleLable.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            authButton.topAnchor.constraint(equalTo: subTitleLable.bottomAnchor, constant: 48),
            authButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            authButton.heightAnchor.constraint(equalToConstant: 50),
            authButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            authButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            authButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
    }
    
    private func configureViews() {
        authButton.cornerRadius = 25
    }
    
    @objc
    private func handleAuthorizationApple() {
        interactor?.handlerAppleAuth()
    }
}

extension LoginViewController: LoginDisplaying {
    func displayLoginError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
