import Foundation
import UIKit

protocol ConfigDisplaying: AnyObject {
    func displayConfigs(with configModels: [ConfigCellModel])
    func displayEditNameAlert(title: String, message: String)
    func displayEditJobAlert(title: String, message: String)
    func displayUserData(with model: UserModel)
    func displayImagePicker()
}

final class ConfigViewController: UIViewController {
    private let interactor: ConfigInteracting?
    private var configModels: [ConfigCellModel] = []
    
    private lazy var avatarImage: UIImageView = {
        $0.image = UIImage(systemName: "person.fill")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .black
        $0.backgroundColor = .gray
        return $0
    }(UIImageView())
    
    private lazy var userName: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: $0.font.pointSize)
        return $0
    }(UILabel())
    
    private lazy var userJob: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
        return $0
    }(UILabel())
    
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorColor = .systemGray
        $0.delegate = self
        $0.dataSource = self
        $0.register(ConfigCell.self, forCellReuseIdentifier: "ConfigCell")
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.layer.cornerRadius = 5
        return $0
    }(UITableView())
    
    init(interactor: ConfigInteracting) {
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
        setupNavigation()
        interactor?.getConfigs()
        interactor?.getUserData()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(avatarImage)
        view.addSubview(userName)
        view.addSubview(userJob)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImage.widthAnchor.constraint(equalToConstant: 48),
            avatarImage.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            userName.topAnchor.constraint(equalTo: avatarImage.topAnchor),
            userName.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            userJob.topAnchor.constraint(equalTo: userName.bottomAnchor),
            userJob.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func configureViews() {
        tableView.tableHeaderView = UIView()
        view.backgroundColor = .systemBackground
        avatarImage.layer.cornerRadius = 10
    }
    
    private func setupNavigation() {
        title = "Configurações"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
    }
    
    private func createEditAlert(title: String, message: String, completion: @escaping (UIAlertController) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField()
        completion(alertController)
        present(alertController, animated: true)
    }
}

extension ConfigViewController: ConfigDisplaying {
    func displayConfigs(with configModels: [ConfigCellModel]) {
        self.configModels = configModels
    }
    
    func displayEditNameAlert(title: String, message: String) {
        createEditAlert(title: title, message: message) { alert in
            let alertAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak alert] _ in
                guard let answer = alert?.textFields?.first?.text else { return }
                if !answer.isEmpty {
                    self?.interactor?.setUserName(with: answer)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alert.addAction(alertAction)
            alert.addAction(cancelAction)
        }
    }
    
    func displayEditJobAlert(title: String, message: String) {
        createEditAlert(title: title, message: message) { alert in
            let alertAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak alert] _ in
                guard let answer = alert?.textFields?.first?.text else { return }
                if !answer.isEmpty {
                    self?.interactor?.setUserJob(with: answer)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
            alert.addAction(alertAction)
            alert.addAction(cancelAction)
        }
    }
    
    func displayUserData(with model: UserModel) {
        userName.text = model.userName
        userJob.text = model.userJob
        guard let imageData = model.userPhoto else { return }
        avatarImage.image = UIImage(data: imageData)
    }
    
    func displayImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
}

extension ConfigViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage,
        let imageData = userPickedImage.pngData() else { return }
        interactor?.setUserImage(with: imageData)
        picker.dismiss(animated: true)
    }
}

extension ConfigViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        configModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConfigCell", for: indexPath) as? ConfigCell
        guard let configCell = cell else {
            return UITableViewCell()
        }
        
        let model = configModels[indexPath.row]
        configCell.setupCell(title: model.title, type: model.type)
        configCell.selectionStyle = .none
        return configCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ConfigCell else { return }
        guard let type = cell.cellType else { return }
        interactor?.handlerConfigTap(from: type)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}
