import Foundation

protocol AnalyticsPresenting: AnyObject {}

final class AnalyticsPresenter: AnalyticsPresenting {
    weak var viewController: AnalyticsDisplay?
}
