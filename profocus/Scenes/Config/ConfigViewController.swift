import Foundation
import UIKit

enum ConfigType {
    case editName
    case editJob
    case editPhoto
    case logout
    case linkRepo
}

// TODO: Create model file
struct ConfigCellModel {
    let title: String
    let type: ConfigType
}

protocol ConfigDisplaying: AnyObject {}

final class ConfigViewController: UIViewController {
    private let interactor: ConfigInteracting?
    // TODO: Get from interactor
    private let configModels: [ConfigCellModel] = [.init(title: "Editar nome", type: .editName),
                                                   .init(title: "Editar função", type: .editJob),
                                                   .init(title: "Editar Photo", type: .editPhoto),
                                                   .init(title: "Link do repositório", type: .linkRepo),
                                                   .init(title: "Sair", type: .logout)]
    
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
    }
    
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func configureViews() {
        tableView.tableHeaderView = UIView()
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigation() {
        title = "Configurações"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
    }
}

extension ConfigViewController: ConfigDisplaying {}

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
        
        switch cell.cellType {
        case .editName:
            print("editName")
        case .editJob:
            print("editJob")
        case .editPhoto:
            print("editPhoto")
        case .linkRepo:
            print("linkRepo")
        case .logout:
            print("logout")
        case .none:
            print("Error celltype not setted")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}
