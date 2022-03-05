import CoreData
import Foundation
import UIKit

protocol TasksDisplaying: AnyObject {
    func displayTasks(task: [NSManagedObject])
}

final class TasksViewController: UIViewController {
    private var interactor: TasksInteracting?
    private var tasks: [NSManagedObject] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorColor = .systemGray
        $0.delegate = self
        $0.dataSource = self
        $0.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        $0.backgroundColor = .systemGray4
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.getTasks()
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

extension TasksViewController: TasksDisplaying {
    func displayTasks(task: [NSManagedObject]) {
        tasks = task
        tableView.reloadData()
    }
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell
        guard let taskCell = cell else {
            return UITableViewCell()
        }
        
        let task = tasks[indexPath.row]
        taskCell.selectionStyle = .none
        taskCell.setTitle(with: task.value(forKey: "name") as? String ?? "" )
        
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.handlerTaskData(task: tasks[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        48
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deletAction = UIContextualAction(style: .destructive,
                                             title: "Apagar") { [weak self] _,_,_ in
            self?.showDeleteAlert(indexPath: indexPath.row)
        }
        
        return .init(actions: [deletAction])
    }
    
    private func showDeleteAlert(indexPath: Int) {
        let alert = UIAlertController(title: "Deseja realmente apagar essa tarefa?",
                                      message: "Uma vez apagado a ação não poderá ser desfeita",
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Sim", style: .destructive, handler: {_ in
            self.interactor?.deletTask(object: self.tasks[indexPath])
        })
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
