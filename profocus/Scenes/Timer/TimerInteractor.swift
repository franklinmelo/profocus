import Foundation

protocol TimerInterecting: AnyObject {
    func getUserInfos()
    func startTimer()
    func stopTimer()
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
    
    func stopTimer() {
        presenter?.presentStartTimer()
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
}
