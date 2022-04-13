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
            createViewController(rootViewController: TasksFactory().make(), tabIcon: UIImage(systemName: "list.bullet"), tabTitle: "Tarefas"),
            createViewController(rootViewController: AnalyticsFactory().make(), tabIcon: UIImage(systemName: "chart.bar.xaxis"), tabTitle: "Resultados"),
            createViewController(rootViewController: ConfigFactory().make(), tabIcon: UIImage(systemName: "gear"), tabTitle: "Configurações")
        ]
    }
    
    private func createViewController(rootViewController: UIViewController, tabIcon: UIImage?, tabTitle: String) -> UIViewController {
        let navigationContoller = UINavigationController(rootViewController: rootViewController)
        navigationContoller.tabBarItem.image = tabIcon
        navigationContoller.tabBarItem.title = tabTitle
        return navigationContoller
    }
}
