import Charts
import Foundation

protocol AnalyticsPresenting: AnyObject {
    func presentChartData(values: [PieChartDataEntry])
    func presentTasks()
    func presentTaskDetails(with task: Task)
}

final class AnalyticsPresenter: AnalyticsPresenting {
    weak var viewController: AnalyticsDisplay?
    private var coordinator: AnalyticsCoordinating
    
    init(coordinator: AnalyticsCoordinating) {
        self.coordinator = coordinator
    }
    
    func presentChartData(values: [PieChartDataEntry]) {
        viewController?.displayChartData(values: values)
    }
    
    func presentTasks() {
        viewController?.displayTasks()
    }
    
    func presentTaskDetails(with task: Task) {
        coordinator.openTaskDetails(with: task)
    }
}
