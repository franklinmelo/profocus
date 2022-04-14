import Foundation
import UIKit

protocol CategoriesDisplaying: AnyObject {
    func displayCategories()
}

final class CategoriesViewController: UIViewController {
    private let interactor: CategoriesInterecting
    
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.register(CategoriesCell.self, forCellReuseIdentifier: "CategoriesCell")
        $0.layer.cornerRadius = 5
        $0.separatorColor = .systemGray
        return $0
    }(UITableView())
    
    private let searchController: UISearchController = {
        $0.searchBar.placeholder = "Busque tarefas"
        $0.hidesNavigationBarDuringPresentation = false
        return $0
    }(UISearchController(searchResultsController: nil))
    
    private lazy var addButton: UIBarButtonItem = {
        return $0
    }(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddCategories)))
    
    init(interactor: CategoriesInterecting) {
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
        interactor.getCategories()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
    
    private func configureViews() {
        tableView.tableHeaderView = UIView()
        searchController.searchResultsUpdater = self
    }
    
    private func setupNavigation() {
        title = "Categorias"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func didTapAddCategories() {
        let alert = UIAlertController(title: "Adicionar Categoria",
                                      message: "Digite o nome da categoria que gostaria de adicionar",
                                      preferredStyle: .alert)
        alert.addTextField()
        
        let addAction = UIAlertAction(title: "Adicionar", style: .default) { [weak self, weak alert] _ in
            guard let textFieldValue = alert?.textFields?.first?.text, !textFieldValue.isEmpty else { return }
            self?.interactor.addCategorie(with: textFieldValue)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive)
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true)
    }
}

extension CategoriesViewController: CategoriesDisplaying {
    func displayCategories() {
        tableView.reloadData()
    }
}

extension CategoriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        interactor.filterCategories(for: searchText)
    }
}

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !interactor.filteredCategories.isEmpty {
            return interactor.filteredCategories.count
        }
        return interactor.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesCell") as? CategoriesCell else {
            return UITableViewCell()
        }
        
        let isFiltered = interactor.filteredCategories.isEmpty
        let title = isFiltered ? interactor.categories[indexPath.row].name : interactor.filteredCategories[indexPath.row].name
        cell.selectionStyle = .none
        cell.setTitle(with: title ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [.init(style: .destructive, title: "Deletar", handler: { [weak self] _, _, _ in
            guard let categorie = self?.interactor.categories[indexPath.row] else { return }
            self?.interactor.deleteCategorie(categorie: categorie)
        })])
    }
}
