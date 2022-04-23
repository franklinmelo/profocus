import Charts
import Foundation

protocol AnalyticsPresenting: AnyObject {
    func presentChartData(values: [PieChartDataEntry])
    func presentTasks()
}

final class AnalyticsPresenter: AnalyticsPresenting {
    weak var viewController: AnalyticsDisplay?
    
    func presentChartData(values: [PieChartDataEntry]) {
        viewController?.displayChartData(values: values)
    }
    
    func presentTasks() {
        viewController?.displayTasks()
    }
}
