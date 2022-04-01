import Charts
import CoreData
import Foundation
import UIKit

protocol AnalyticsInteracting: AnyObject {
    func getTasks()
}

final class AnalyticsInteractor: AnalyticsInteracting {
    private var presenter: AnalyticsPresenting?
    private var tasks: [Task] = []
    private var totalTime = 0.0
    
    private var domTasks: [Task] = []
    private var segTasks: [Task] = []
    private var terTasks: [Task] = []
    private var quaTasks: [Task] = []
    private var quiTasks: [Task] = []
    private var sexTasks: [Task] = []
    private var sabTasks: [Task] = []
    
    
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
            
            splitTaskForDay()
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
    private func convertTimestampToDate(timestamp: TimeInterval) -> Date {
        Date(timeIntervalSince1970: timestamp)
    }
    
    private func splitTaskForDay() {
        domTasks = tasks.filter { Calendar.current.component(.weekday, from: convertTimestampToDate(timestamp: $0.createdAt)) == 1 }
        let domTime = countTimeForDay(task: domTasks)
        
        segTasks = tasks.filter { Calendar.current.component(.weekday, from: convertTimestampToDate(timestamp: $0.createdAt)) == 2 }
        let segTime = countTimeForDay(task: segTasks)
        
        terTasks = tasks.filter { Calendar.current.component(.weekday, from: convertTimestampToDate(timestamp: $0.createdAt)) == 3 }
        let terTime = countTimeForDay(task: terTasks)
        
        quaTasks = tasks.filter { Calendar.current.component(.weekday, from: convertTimestampToDate(timestamp: $0.createdAt)) == 4 }
        let quaTime = countTimeForDay(task: quaTasks)
        
        quiTasks = tasks.filter { Calendar.current.component(.weekday, from: convertTimestampToDate(timestamp: $0.createdAt)) == 5 }
        let quiTime = countTimeForDay(task: quiTasks)
        
        sexTasks = tasks.filter { Calendar.current.component(.weekday, from: convertTimestampToDate(timestamp: $0.createdAt)) == 6 }
        let sexTime = countTimeForDay(task: sexTasks)
        
        sabTasks = tasks.filter { Calendar.current.component(.weekday, from: convertTimestampToDate(timestamp: $0.createdAt)) == 7 }
        let sabTime = countTimeForDay(task: sabTasks)
        
        let values: [BarChartDataEntry] = [
            BarChartDataEntry(x: 0.0, y: domTime),
            BarChartDataEntry(x: 1.0, y: segTime),
            BarChartDataEntry(x: 2.0, y: terTime),
            BarChartDataEntry(x: 3.0, y: quaTime),
            BarChartDataEntry(x: 4.0, y: quiTime),
            BarChartDataEntry(x: 5.0, y: sexTime),
            BarChartDataEntry(x: 6.0, y: sabTime)
        ]
        
        presenter?.presentChartData(values: values)
    }
    
    private func countTimeForDay(task: [Task]) -> Double {
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
