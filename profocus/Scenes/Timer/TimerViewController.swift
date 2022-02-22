import UIKit

protocol TimerDisplaying: AnyObject {
    func doSomeThing()
}

final class TimerViewController: UIViewController {
    private var interactor: TimerInterecting?
    
    private lazy var avatarImage: UIImageView = {
        $0.image = UIImage(systemName: "person.fill")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .black
        $0.backgroundColor = .gray
        return $0
    }(UIImageView())
    
    private lazy var userName: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Franklin Melo"
        $0.font = UIFont.boldSystemFont(ofSize: $0.font.pointSize)
        return $0
    }(UILabel())
    
    private lazy var userJob: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Desenvolvedor iOS"
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
    }
    
    private func setupViews() {
        view.addSubview(avatarImage)
        view.addSubview(userName)
        view.addSubview(userJob)
        view.addSubview(settingsButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImage.widthAnchor.constraint(equalToConstant: 44),
            avatarImage.heightAnchor.constraint(equalToConstant: 44)
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
    }
    
    private func configureViews() {
        view.backgroundColor = .systemBackground
        avatarImage.layer.cornerRadius = 44 / 2
    }
    
    @objc
    private func didTapSettings() {
        interactor?.doSomeThing()
    }
}

extension TimerViewController: TimerDisplaying {
    func doSomeThing() {}
}
