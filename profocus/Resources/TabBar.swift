import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = .cyan
        tabBar.tintColor = .cyan
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        viewControllers = [
            createViewController(rootViewController: TimerFactory().make(), tabIcon: UIImage(systemName: "timer"), tabTitle: "Timer"),
            createViewController(rootViewController: TasksFactory().make(), tabIcon: UIImage(systemName: "list.bullet"), tabTitle: "Tarefas"),
            createViewController(rootViewController: AnalyticsFactory().make(), tabIcon: UIImage(systemName: "chart.bar.xaxis"), tabTitle: "Resultados")
        ]
    }
    
    private func createViewController(rootViewController: UIViewController, tabIcon: UIImage?, tabTitle: String) -> UIViewController {
        let navigationContoller = UINavigationController(rootViewController: rootViewController)
        navigationContoller.tabBarItem.image = tabIcon
        navigationContoller.tabBarItem.title = tabTitle
        return navigationContoller
    }
}
