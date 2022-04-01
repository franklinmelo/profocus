import Charts
import Foundation

protocol AnalyticsPresenting: AnyObject {
    func presentChartData(values: [BarChartDataEntry])
}

final class AnalyticsPresenter: AnalyticsPresenting {
    weak var viewController: AnalyticsDisplay?
    
    func presentChartData(values: [BarChartDataEntry]) {
        viewController?.displayChartData(values: values)
    }
}
