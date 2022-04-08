import Foundation
import UIKit

protocol PresentationDelegate: AnyObject {
    func didDismiss()
}


protocol AddTaskDisplaing: AnyObject {}

final class AddTaskViewController: UIViewController {
    private var interactor: AddTaskInteracting?
    weak var delegate: PresentationDelegate?
    
    private lazy var containerView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    lazy var dimmedView: UIView = {
        $0.backgroundColor = .black
        $0.alpha = 0.6
        return $0
    }(UIView())
    
    init(interactor: AddTaskInteracting) {
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didDismiss()
    }
    
    private func setupViews() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func configureViews() {}
    
}

extension AddTaskViewController: AddTaskDisplaing{

}
