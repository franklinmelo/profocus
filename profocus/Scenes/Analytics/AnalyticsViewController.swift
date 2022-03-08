import Charts
import Foundation
import UIKit

protocol AnalyticsDisplay: AnyObject {}

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
    
    let values: [BarChartDataEntry] = [
        BarChartDataEntry(x: 0.0, y: 1.0),
        BarChartDataEntry(x: 1.0, y: 2.0),
        BarChartDataEntry(x: 2.0, y: 4.0),
        BarChartDataEntry(x: 3.0, y: 5.0),
        BarChartDataEntry(x: 4.0, y: 6.0),
        BarChartDataEntry(x: 5.0, y: 7.0),
        BarChartDataEntry(x: 6.0, y: 12.0)
    ]
    
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
        setChartData()
    }
    
    private func setupNavigation() {
        title = "Resultados"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setChartData() {
        let set = BarChartDataSet(entries: values, label: "Tempo de foco em minutos")
        set.colors = [NSUIColor(ciColor: .cyan)]
        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 12))
        chartView.data = data
    }
}

extension AnalyticsViewController: AnalyticsDisplay {}

extension AnalyticsViewController: ChartViewDelegate {}


class WeekValueFormatter: NSObject, IAxisValueFormatter {

    override init() {
        super.init()
    }

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let week = ["SEG", "TER", "QUA", "QUI", "SEX", "SAB", "DOM"]
        return week[Int(value)]
    }
}
