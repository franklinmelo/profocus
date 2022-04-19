import CoreData
import Foundation
import UIKit

protocol TasksDisplaying: AnyObject {
    func displayTasks(task: [Task])
    func displayFilteredTasks(tasks: [Task])
}

final class TasksViewController: UIViewController {
    private var interactor: TasksInteracting?
    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []
    
    private let searchController: UISearchController = {
        $0.searchBar.placeholder = "Busque tarefas"
        $0.hidesNavigationBarDuringPresentation = false
        return $0
    }(UISearchController(searchResultsController: nil))
    
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
    
    private lazy var addTaskButton: UIBarButtonItem = {
        return $0
    }(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddTask)))
    
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
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
        searchController.searchResultsUpdater = self
    }
    
    private func setupNavigation() {
        title = "Tarefas diárias"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = addTaskButton
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
    
    @objc
    private func didTapAddTask() {
        guard let viewController = AddTaskFactory.make() as? AddTaskViewController else { return }
        viewController.delegate = self
        present(viewController, animated: true)
    }
}

extension TasksViewController: TasksDisplaying {
    func displayTasks(task: [Task]) {
        tasks = task
        tableView.reloadData()
    }
    
    func displayFilteredTasks(tasks: [Task]) {
        filteredTasks = tasks
        tableView.reloadData()
    }
}

extension TasksViewController: PresentationDelegate {
    func didDismiss() {
        interactor?.getTasks()
    }
}

extension TasksViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        interactor?.filterTasks(for: searchText)
    }
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredTasks.count
        }
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell
        guard let taskCell = cell else {
            return UITableViewCell()
        }
        
        var task: NSManagedObject
        task = isFiltering ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        taskCell.selectionStyle = .none
        taskCell.setTitle(with: task.value(forKey: "name") as? String ?? "" )
        
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task: Task
        task = isFiltering ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        interactor?.handlerTaskData(task: task)
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
}
