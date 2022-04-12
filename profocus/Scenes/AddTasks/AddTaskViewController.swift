import Foundation
import UIKit

protocol PresentationDelegate: AnyObject {
    func didDismiss()
}


protocol AddTaskDisplaing: AnyObject {}

private extension AddTaskViewController.Layout {
    struct container {
       static var bottonContraint: NSLayoutConstraint = NSLayoutConstraint()
    }
}

final class AddTaskViewController: UIViewController {
    fileprivate enum Layout {}
    
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
        $0.backgroundColor = .systemGray4
        $0.layer.cornerRadius = 10
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        $0.delegate = self
        return $0
    }(UITextField())
    
    private lazy var picker: UIPickerView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(UIPickerView())
    
    private lazy var createButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Criar Tarefa", for: .normal)
        $0.backgroundColor = .systemIndigo
        $0.addTarget(self, action: #selector(didTapCreateTask), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var cancelButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Cancelar", for: .normal)
        $0.backgroundColor = .red.withAlphaComponent(0.75)
        $0.addTarget(self, action: #selector(didTapCancelTask), for: .touchUpInside)
        return $0
    }(UIButton())
    
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
        interactor?.getCategories()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didDismiss()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupViews() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        containerView.addSubview(titleLable)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(textField)
        containerView.addSubview(picker)
        containerView.addSubview(createButton)
        containerView.addSubview(cancelButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        Layout.container.bottonContraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            Layout.container.bottonContraint,
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2)
        ])
        
        
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLable.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            titleLable.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            picker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            picker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            picker.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            createButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            createButton.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            cancelButton.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    private func configureViews() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        createButton.layer.cornerRadius = 35 / 2
        cancelButton.layer.cornerRadius = 35 / 2
    }

    @objc
    private func changeKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            Layout.container.bottonContraint.constant = 0
        } else {
            Layout.container.bottonContraint.constant = -keyboardScreenEndFrame.height
        }
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.containerView.layoutIfNeeded()
        }
    }
    
    @objc
    private func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func didTapCreateTask() {
        guard let textFieldValue = textField.text else { return }
        if !textFieldValue.isEmpty {
            interactor?.createTask(title: textFieldValue , categorieIntex: picker.selectedRow(inComponent: 0))
            self.dismiss(animated: true)
            return
        }
        
        let alert = UIAlertController(title: "Ops!", message: "Insira um titulo para sua tarefa", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    @objc
    private func didTapCancelTask() {
        self.dismiss(animated: true)
    }
}

extension AddTaskViewController: AddTaskDisplaing{}

extension AddTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        interactor?.categories.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let title = interactor?.categories[row].value(forKey: "name") as? String else {
            return "Não definido"
        }
        return title
    }
}
