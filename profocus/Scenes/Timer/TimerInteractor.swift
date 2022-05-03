import CoreData
import Foundation
import UIKit

protocol TimerInterecting: AnyObject {
    func setTaskTitle()
    func startTimer()
    func stopTimer()
}

final class TimerInteractor {
    private var presenter: TimerPresenting?
    private var timer: Timer?
    private var timerCountSec = 0
    private var timerCountMin = 0
    private var task: Task?
    private var notificationCenter: NotificationCenter
    
    init(presenter: TimerPresenting, task: Task, notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.presenter = presenter
        self.task = task
        self.notificationCenter = notificationCenter
        addNotificationObserver()
    }
    
    private func addNotificationObserver() {
        notificationCenter.addObserver(self, selector: #selector(enterInBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc
    private func enterInBackground() {
        stopTimer()
        presenter?.presentAlertBackground()
    }
    
    @objc
    private func fireTimer() {
        if timerCountSec < 59 {
            timerCountSec += 1
        } else {
            timerCountSec = 0
            timerCountMin += 1
        }
        let totalTime = String(format: "%02d:%02d", timerCountMin, timerCountSec)
        presenter?.presentTimer(with: totalTime)
    }
    
    private func save(taskMin: Int, taskSec: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.taskContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        fetchRequest.predicate = NSPredicate(format: "id = %@", (task?.id?.uuidString ?? ""))
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            guard let task = result.first else { return }
            task.timeMin = Int16(taskMin)
            task.timeSec = Int16(taskSec)
            task.completed = true
            try managedContext.save()
        } catch {
            print("Error on get Tasks")
        }
    }
}

extension TimerInteractor: TimerInterecting {
    func setTaskTitle() {
        guard let task = task else { return }
        presenter?.presentTaskInfo(with: task)
    }
    
    func startTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
        presenter?.presentStopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(fireTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopTimer() {
        UIApplication.shared.isIdleTimerDisabled = false
        presenter?.presentStartTimer()
        save(taskMin: timerCountMin,
             taskSec: timerCountSec)
        timer?.invalidate()
        timerCountSec = 0
        timerCountMin = 0
        presenter?.presentTimer(with: "00:00")
    }
}
