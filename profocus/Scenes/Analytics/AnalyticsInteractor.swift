import Charts
import CoreData
import Foundation
import UIKit

protocol AnalyticsInteracting: AnyObject {
    var tasks: [Task] { get set }
    func getTasks()
}

final class AnalyticsInteractor: AnalyticsInteracting {
    private var presenter: AnalyticsPresenting?
    var tasks: [Task] = []
    private var categories: Set<Categorie> = []
    
    init(presenter: AnalyticsPresenting) {
        self.presenter = presenter
    }
    
    func getTasks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.taskContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        
        do {
            let data = try managedContext.fetch(fetchRequest)
            let currentWeekDay = Calendar.current.component(.weekday, from: Date.now)
            let minimuDay = Calendar.current.date(byAdding: DateComponents(day: -currentWeekDay), to: Date.now)
            
            tasks = data.filter { convertTimestampToDate(timestamp: $0.createdAt) >= minimuDay ?? Date.now}
            tasks.forEach {
                guard let categorie = $0.categorie else { return }
                categories.insert(categorie)
            }
            presenter?.presentTasks()
            splitTaskForCategory()
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
    private func convertTimestampToDate(timestamp: TimeInterval) -> Date {
        Date(timeIntervalSince1970: timestamp)
    }
    
    private func splitTaskForCategory() {
        var values: [PieChartDataEntry] = []
        
        categories.forEach { categorie in
            let tasks = tasks.filter { $0.categorie == categorie }
            let tasksTime = countTimeForCateorie(task: tasks)
            let dataEntry = PieChartDataEntry(value: tasksTime, label: categorie.name)
            values.append(dataEntry)
        }
        
        presenter?.presentChartData(values: values)
    }
    
    private func countTimeForCateorie(task: [Task]) -> Double {
        if !task.isEmpty {
            var totalMin = 0.0
            var totalSec = 0.0
            var totalTime = 0.0
            
            task.forEach {
                totalMin += Double($0.timeMin)
                totalSec += Double($0.timeSec)
            }
            
            totalTime = (totalSec / 60) + totalMin
            return totalTime
        }
        return 0.0
    }
}
