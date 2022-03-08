import Foundation

protocol AnalyticsInteracting: AnyObject {}

final class AnalyticsInteractor: AnalyticsInteracting {
    private var presenter: AnalyticsPresenting?
    
    init(presenter: AnalyticsPresenting) {
        self.presenter = presenter
    }
}
