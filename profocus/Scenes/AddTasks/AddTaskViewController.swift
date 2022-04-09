import Foundation
import UIKit

protocol PresentationDelegate: AnyObject {
    func didDismiss()
}


protocol AddTaskDisplaing: AnyObject {
    func displayShowKeyboard()
    func displayHideKeyboard()
}

final class AddTaskViewController: UIViewController {
    private var interactor: AddTaskInteracting?
    weak var delegate: PresentationDelegate?
    
    private lazy var containerView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    private lazy var dimmedView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
        $0.alpha = 0.6
        return $0
    }(UIView())
    
    private lazy var titleLable: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .title1)
        $0.text = "Adicionar Tarefa"
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.text = "Insira o nome da tarefa e selecione uma categoria"
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private lazy var textField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Digite o nome da tarefa"
        $0.returnKeyType = .done
        $0.delegate = self
        return $0
    }(UITextField())
    
    init(interactor: AddTaskInteracting) {
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
        NotificationCenter.default.addObserver(self, selector: #selector(changeKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didDismiss()
    }
    
    private func setupViews() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        containerView.addSubview(titleLable)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(textField)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLable.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 12),
            titleLable.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 12),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
        ])
    }
    
    private func configureViews() {}

    @objc
    private func changeKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .zero).isActive = true
        } else {
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardScreenEndFrame.height).isActive = true
        }
        
        //Add animation
        containerView.layoutIfNeeded()
    }
    
}

extension AddTaskViewController: AddTaskDisplaing{
    func displayShowKeyboard() {}
    
    func displayHideKeyboard() {}
}

extension AddTaskViewController: UITextFieldDelegate {
    
}
