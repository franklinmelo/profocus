import Foundation
import UIKit

protocol ConfigDisplaying: AnyObject {
    func displayConfigs(with configModels: [ConfigCellModel])
}

final class ConfigViewController: UIViewController {
    private let interactor: ConfigInteracting?
    private var configModels: [ConfigCellModel] = []
    
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

extension ConfigViewController: ConfigDisplaying {
    func displayConfigs(with configModels: [ConfigCellModel]) {
        self.configModels = configModels
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
