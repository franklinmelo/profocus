import Foundation
import UIKit

protocol TaskDetailsDisplay: AnyObject {
    func displayTaskData(task: Task)
}

final class TaskDetailsViewController: UIViewController {
    private var interactor: TaskDetailsInteracting?
    
    lazy var taskName: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    lazy var taskCategorie: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    lazy var taskTime: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    lazy var taskDate: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    init(interactor: TaskDetailsInteracting) {
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
        interactor?.fillTaskData()
    }
    
    private func setupViews() {
        view.addSubview(taskName)
        view.addSubview(taskCategorie)
        view.addSubview(taskTime)
        view.addSubview(taskDate)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            taskName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            taskName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            taskName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            taskCategorie.topAnchor.constraint(equalTo: taskName.bottomAnchor, constant: 20),
            taskCategorie.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            taskCategorie.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            taskTime.topAnchor.constraint(equalTo: taskCategorie.bottomAnchor, constant: 20),
            taskTime.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            taskTime.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            taskDate.topAnchor.constraint(equalTo: taskTime.bottomAnchor, constant: 20),
            taskDate.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            taskDate.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureViews() {
        
    }
    
    private func setupNavigation() {
        title = "Informações sobre a tarefa"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension TaskDetailsViewController: TaskDetailsDisplay {
    func displayTaskData(task: Task) {
        guard let name = task.name, let categorie = task.categorie?.name else { return }
        let date = Date(timeIntervalSince1970: task.createdAt).formatted(date: .numeric, time: .omitted)
        taskName.text = "Tarefa: \(name)"
        taskCategorie.text = "Categoria: \(categorie)"
        taskTime.text = "Tempo da tefera: \(task.timeMin) min e \(task.timeSec) sec"
        taskDate.text = "Tarefa criada em: \(date)"
    }
}
