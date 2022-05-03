import UIKit

protocol TimerDisplaying: AnyObject {
    func displayTaskInfos(with task: Task)
    func displayStartTimer()
    func displayStopTimer()
    func displayUpdateTimer(with time: String)
    func displayAlertBackground()
}

final class TimerViewController: UIViewController {
    private var interactor: TimerInterecting?
    
    // MARK: - Timer components
    private lazy var timerContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .cyan.withAlphaComponent(0.75)
        $0.layer.cornerRadius = 15
        return $0
    }(UIView())
    
    private lazy var timerTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .title1)
        return $0
    }(UILabel())
    
    private lazy var timerCategorie: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: 28)
        return $0
    }(UILabel())
    
    private lazy var timerClock: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "00:00"
        $0.font = UIFont.boldSystemFont(ofSize: 96)
        return $0
    }(UILabel())
    
    private lazy var timerButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Start!", for: .normal)
        $0.backgroundColor = .systemIndigo
        $0.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        return $0
    }(UIButton())
    
    init(interactor: TimerInterecting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureViews()
        interactor?.setTaskTitle()
    }
    
    private func setupViews() {
        timerContainer.addSubview(timerTitle)
        timerContainer.addSubview(timerCategorie)
        timerContainer.addSubview(timerClock)
        timerContainer.addSubview(timerButton)
        view.addSubview(timerContainer)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            timerTitle.centerXAnchor.constraint(equalTo: timerContainer.centerXAnchor),
            timerTitle.topAnchor.constraint(equalTo: timerContainer.topAnchor, constant: 24)
        ])
        
        NSLayoutConstraint.activate([
            timerCategorie.centerXAnchor.constraint(equalTo: timerContainer.centerXAnchor),
            timerCategorie.topAnchor.constraint(equalTo: timerTitle.bottomAnchor, constant: 16)
            
        ])
        
        NSLayoutConstraint.activate([
            timerClock.centerXAnchor.constraint(equalTo: timerContainer.centerXAnchor),
            timerClock.centerYAnchor.constraint(equalTo: timerContainer.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            timerButton.centerXAnchor.constraint(equalTo: timerContainer.centerXAnchor),
            timerButton.bottomAnchor.constraint(equalTo: timerContainer.bottomAnchor, constant: -24),
            timerButton.heightAnchor.constraint(equalToConstant: 35),
            timerButton.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        NSLayoutConstraint.activate([
            timerContainer.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
            timerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            timerContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timerContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        timerButton.layer.cornerRadius = 35 / 2
        title = "Tempo de Foco"
    }
    
    @objc
    private func didTapStart() {
        let alert = createAlert(title: "Hora de focar!",
                                message: "Deseja iniciar o contador de tempo da sua tarefa? Uma vez iniciado não poderá ser pausado e caso o app seja minimizado ou fechado o contador ira parar.",
                                cancelActionTitle: "Cancelar")
        
        let alertAction = UIAlertAction(title: "Iniciar", style: .default) { [weak self] _ in
            self?.interactor?.startTimer()
        }
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
    
    @objc
    private func didTapStop() {
        let alertAction: (UIAlertAction) -> Void = {_ in
            self.interactor?.stopTimer()
            self.navigationController?.popViewController(animated: true)
        }
        let alert = createAlert(title: "Deseja realmente parar?",
                                confirmActionTitle: "Sim",
                                confirmActionHandler: alertAction,
                                cancelActionTitle: "Não")
        
        present(alert, animated: true)
    }
    
    private func createAlert(title: String?,
                             message: String? = nil,
                             confirmActionTitle: String? = nil,
                             confirmActionHandler: ((UIAlertAction) -> Void)? = nil,
                             cancelActionTitle: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let confirmActionTitle = confirmActionTitle {
            let confirmAction = UIAlertAction(title: confirmActionTitle, style: .default, handler: confirmActionHandler)
            alert.addAction(confirmAction)
        }
        
        if let cancelTitle = cancelActionTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        return alert
    }
}

extension TimerViewController: TimerDisplaying {
    func displayTaskInfos(with task: Task) {
        timerTitle.text = task.name
        timerCategorie.text = task.categorie?.name
    }
    
    func displayStartTimer() {
        timerButton.removeTarget(self, action: #selector(didTapStop), for: .touchUpInside)
        timerButton.setTitle("Start!", for: .normal)
        timerButton.backgroundColor = .systemIndigo
        timerButton.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
    }
    
    func displayStopTimer() {
        timerButton.removeTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        timerButton.setTitle("Stop!", for: .normal)
        timerButton.backgroundColor = .red.withAlphaComponent(0.75)
        timerButton.addTarget(self, action: #selector(didTapStop), for: .touchUpInside)
    }
    
    func displayUpdateTimer(with time: String) {
        timerClock.text = time
    }
    
    func displayAlertBackground() {
        let alert = createAlert(title: "Ops!",
                                message: "O contador de tempo da sua tarefa foi parado pois você saiu do App e desviou o foco",
                                confirmActionTitle: "Ok",
                                confirmActionHandler: { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        },
                                cancelActionTitle: nil)
        present(alert, animated: true)
    }
}
