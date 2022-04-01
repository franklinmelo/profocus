import Charts
import Foundation
import UIKit

protocol AnalyticsDisplay: AnyObject {
    func displayChartData(values: [BarChartDataEntry])
}

final class AnalyticsViewController: UIViewController {
    private var interactor: AnalyticsInteracting?
    
    private lazy var chartView: BarChartView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isUserInteractionEnabled = false
        $0.dragEnabled = true
        $0.setScaleEnabled(false)
        $0.pinchZoomEnabled = false
        $0.backgroundColor = .systemGray4
        
        $0.xAxis.valueFormatter = WeekValueFormatter()
        $0.xAxis.labelPosition = .bottom
        $0.xAxis.drawGridLinesEnabled = false
        $0.xAxis.labelCount = 7
        $0.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        
        return $0
    }(BarChartView())
    
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
        view.addSubview(chartView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            chartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            chartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
    }
    
    private func configureViews() {
        chartView.layer.cornerRadius = 5
    }
    
    private func setupNavigation() {
        title = "Resultados"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setChartData(with entries: [BarChartDataEntry]) {
        let set = BarChartDataSet(entries: entries, label: "Tempo de foco em minutos")
        set.colors = [NSUIColor(ciColor: .cyan)]
        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 12))
        chartView.data = data
    }
}

extension AnalyticsViewController: AnalyticsDisplay {
    func displayChartData(values: [BarChartDataEntry]) {
        setChartData(with: values)
    }
}

extension AnalyticsViewController: ChartViewDelegate {}


class WeekValueFormatter: NSObject, IAxisValueFormatter {

    override init() {
        super.init()
    }

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let week = ["DOM", "SEG", "TER", "QUA", "QUI", "SEX", "SAB"]
        return week[Int(value)]
    }
}
