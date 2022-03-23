import CoreData
import Foundation
import UIKit

protocol TimerInterecting: AnyObject {
    func getUserInfos()
    func startTimer()
    func stopTimer(with taskName: String)
    func openSettings()
}

final class TimerInteractor {
    private var presenter: TimerPresenting?
    private var timer: Timer?
    private var timerCountSec = 0
    private var timerCountMin = 0
    
    init(presenter: TimerPresenting) {
        self.presenter = presenter
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
    
    private func save(taskMin: Int, taskSec: Int, taskName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.taskContainer.viewContext
        
        let task = Task(context: managedContext)
        
        task.timeMin = Int16(taskMin)
        task.timeSec = Int16(taskSec)
        task.name = taskName
        task.createdAt = Date().timeIntervalSince1970
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save. \(error)")
        }
    }
}

extension TimerInteractor: TimerInterecting {
    func getUserInfos() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.userContainer.viewContext
        
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do {
            let userData = try managedContext.fetch(fetchRequest)
            presenter?.presentUserInfos(with: .init(userName: userData.last?.name ?? "Usuário ProFocus",
                                                    userJob: userData.last?.job ?? ""))
        } catch {
            print("Could not fetch. \(error)")
        }
    }
    
    func startTimer() {
        presenter?.presentStopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(fireTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopTimer(with taskName: String) {
        presenter?.presentStartTimer()
        save(taskMin: timerCountMin,
             taskSec: timerCountSec,
             taskName: taskName)
        timer?.invalidate()
        timerCountSec = 0
        timerCountMin = 0
        presenter?.presentTimer(with: "00:00")
    }
    
    func openSettings() {
        presenter?.presentSettings()
    }
}
