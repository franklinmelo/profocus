import Foundation
import UIKit

protocol TasksDisplaying: AnyObject {}

final class TasksViewController: UIViewController {
    private var interactor: TasksInteracting?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
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
    
    private func setupViews() {}
    
    private func setupConstraints() {}
    
    private func configureViews() {}
    
    private func setupNavigation() {
        title = "Tarefas diárias"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.placeholder = "Busque tarefas"
        navigationItem.searchController = searchController
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
    }
}

extension TasksViewController: TasksDisplaying {}
