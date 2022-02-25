import UIKit

protocol TimerDisplaying: AnyObject {
    func displayUserInfos(with user: UserModel)
    func displayStartTimer()
    func displayStopTimer()
    func displayUpdateTimer(with time: String)
}

final class TimerViewController: UIViewController {
    private var interactor: TimerInterecting?
    
    // MARK: - Header components
    private lazy var avatarImage: UIImageView = {
        $0.image = UIImage(systemName: "person.fill")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .black
        $0.backgroundColor = .gray
        return $0
    }(UIImageView())
    
    private lazy var userName: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: $0.font.pointSize)
        return $0
    }(UILabel())
    
    private lazy var userJob: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
        return $0
    }(UILabel())
    
    private lazy var settingsButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44)), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.tintColor = .gray
        $0.addTarget(self, action: #selector(didTapSettings), for: .touchUpInside)
        return $0
    }(UIButton())
    
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
        interactor?.getUserInfos()
    }
    
    private func setupViews() {
        view.addSubview(avatarImage)
        view.addSubview(userName)
        view.addSubview(userJob)
        view.addSubview(settingsButton)
        
        timerContainer.addSubview(timerTitle)
        timerContainer.addSubview(timerClock)
        timerContainer.addSubview(timerButton)
        view.addSubview(timerContainer)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImage.widthAnchor.constraint(equalToConstant: 48),
            avatarImage.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            userName.topAnchor.constraint(equalTo: avatarImage.topAnchor),
            userName.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            userJob.topAnchor.constraint(equalTo: userName.bottomAnchor),
            userJob.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            settingsButton.widthAnchor.constraint(equalToConstant: 44),
            settingsButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            timerTitle.centerXAnchor.constraint(equalTo: timerContainer.centerXAnchor),
            timerTitle.topAnchor.constraint(equalTo: timerContainer.topAnchor, constant: 24)
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
            timerContainer.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 60),
            timerContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timerContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        avatarImage.layer.cornerRadius = 48 / 2
        timerButton.layer.cornerRadius = 35 / 2
    }
    
    @objc
    private func didTapSettings() {
        print("Tap to settings Button")
    }
    
    @objc
    private func didTapStart() {
        let alert = createAlert(title: "Hora de focar!",
                                message: "Escolha um título para sua tarefa",
                                cancelActionTitle: "Cancelar",
                                withTextField: true)
        
        let alertAction = UIAlertAction(title: "Iniciar", style: .default) { [unowned alert] _ in
            guard let answer = alert.textFields?[0].text else { return }
            if !answer.isEmpty {
                DispatchQueue.main.async {
                    self.timerTitle.text = answer
                    self.interactor?.startTimer()
                }
            }
        }
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
    
    @objc
    private func didTapStop() {
        let alertAction: (UIAlertAction) -> Void = {_ in
            DispatchQueue.main.async {
                self.timerTitle.text = ""
                self.interactor?.stopTimer()
            }
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
                             cancelActionTitle: String,
                             withTextField: Bool = false) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if withTextField {
            alert.addTextField()
        }
        
        if let confirmActionTitle = confirmActionTitle {
            let confirmAction = UIAlertAction(title: confirmActionTitle, style: .default, handler: confirmActionHandler)
            alert.addAction(confirmAction)
        }
        
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        return alert
    }
}

extension TimerViewController: TimerDisplaying {
    func displayUserInfos(with user: UserModel) {
        userName.text = user.userName
        userJob.text = user.userJob
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
}
