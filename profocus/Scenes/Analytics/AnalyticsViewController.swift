import Charts
import Foundation
import UIKit

protocol AnalyticsDisplay: AnyObject {
    func displayChartData(values: [PieChartDataEntry])
    func displayTasks()
}

final class AnalyticsViewController: UIViewController {
    private var interactor: AnalyticsInteracting?
    
    private lazy var chartView: PieChartView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isUserInteractionEnabled = false
        return $0
    }(PieChartView())
    
    private lazy var descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Confira suas tarefas concluídas na última semana e o tempo que passou focado nelas"
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        return $0
    }(UILabel())
    
    private lazy var tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.separatorColor = .systemGray
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 5
        $0.register(DoneTaskCell.self, forCellReuseIdentifier: "DoneTaskCell")
        return $0
    }(UITableView())
    
    init(interactor: AnalyticsInteracting) {
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
        view.addSubview(descriptionLabel)
        view.addSubview(chartView)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            chartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            chartView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureViews() {
        chartView.layer.cornerRadius = 5
    }
    
    private func setupNavigation() {
        title = "Resultados"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setChartData(with entries: [ChartDataEntry]) {
        let pieChartDataSet = PieChartDataSet(entries: entries, label: "Categorias")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        var colors: [UIColor] = []
        
        entries.forEach { _ in
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        chartView.data = pieChartData
    }
    
    private func showDeleteAlert(title: String, message: String, task: Task) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Sim", style: .destructive) { [weak self] _ in
            self?.interactor?.deleteTask(task: task)
        }
        let cancelAction = UIAlertAction(title: "Não", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

extension AnalyticsViewController: AnalyticsDisplay {
    func displayChartData(values: [PieChartDataEntry]) {
        chartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
        setChartData(with: values)
    }
    
    func displayTasks() {
        tableView.reloadData()
    }
}

extension AnalyticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [.init(style: .destructive, title: "Apagar", handler: { [weak self] _, _, _ in
            guard let task = self?.interactor?.tasks[indexPath.row] else { return }
            self?.showDeleteAlert(title: "Deseja realmente apagar essa tarefa?",
                                  message: "Uma vez apagado a ação não poderá ser desfeita",
                                  task: task)
        })])
    }
}

extension AnalyticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        interactor?.tasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DoneTaskCell", for: indexPath) as? DoneTaskCell,
              let taskName = interactor?.tasks[indexPath.row].name else {
            return UITableViewCell()
        }
        
        cell.setTitle(with: taskName)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let task = interactor?.tasks[indexPath.row] else { return }
        interactor?.selectTask(task: task)
    }
}
