import Foundation
import UIKit

protocol TasksDisplaying: AnyObject {}

final class TasksViewController: UIViewController {
    
    private let test: [TaskModel] = [.init(name: "Task 1", time: Date().timeIntervalSince1970),
                                     .init(name: "Task 2", time: Date().timeIntervalSince1970),
                                     .init(name: "Task 3", time: Date().timeIntervalSince1970),
                                     .init(name: "Task 4", time: Date().timeIntervalSince1970),
                                     .init(name: "Task 5", time: Date().timeIntervalSince1970)]
    
    private var interactor: TasksInteracting?
    
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorColor = .systemGray
        $0.delegate = self
        $0.dataSource = self
        $0.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.layer.cornerRadius = 5
        return $0
    }(UITableView())
    
    init(interactor: TasksInteracting) {
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
    }
    
    private func setupNavigation() {
        title = "Tarefas diárias"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.placeholder = "Busque tarefas"
        navigationItem.searchController = searchController
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
    }
}

extension TasksViewController: TasksDisplaying {}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell
        guard let taskCell = cell else {
            return UITableViewCell()
        }
        
        let task = test[indexPath.row]
        taskCell.selectionStyle = .none
        taskCell.setTitle(with: task.name)
        
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(test[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deletAction = UIContextualAction(style: .destructive,
                                             title: "Apagar") { _,_,_ in
            print("APAGADO")
        }
        
        return .init(actions: [deletAction])
    }
}
