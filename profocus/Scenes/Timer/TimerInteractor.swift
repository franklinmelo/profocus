import CoreData
import Foundation
import UIKit

protocol TimerInterecting: AnyObject {
    func getUserInfos()
    func startTimer()
    func stopTimer(with taskName: String)
}

final class TimerInteractor: TimerInterecting {
    private var presenter: TimerPresenting?
    private var timer: Timer?
    private var timerCountSec = 0
    private var timerCountMin = 0
    
    init(presenter: TimerPresenting) {
        self.presenter = presenter
    }
    
    func getUserInfos() {
        // TODO: Get this on DB
        presenter?.presentUserInfos(with: .init(userName: "Franklin Melo", userJob: "Desenvolvedor iOS"))
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
    
    @objc
    func fireTimer() {
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
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else { return }
        
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        task.setValue(taskMin, forKey: "timeMin")
        task.setValue(taskSec, forKey: "timeSec")
        task.setValue(taskName, forKey: "name")
        task.setValue(Date().timeIntervalSince1970, forKey: "createdAt")
        
        do {
            try managedContext.save()
        } catch {
            print("Could not save. \(error)")
        }
    }
}
