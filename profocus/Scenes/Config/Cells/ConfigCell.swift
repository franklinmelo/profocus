import UIKit

final class ConfigCell: UITableViewCell {
    private lazy var configTitle: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .preferredFont(forTextStyle: .headline)
        return $0
    }(UILabel())
    
    private lazy var chevronIcon: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "chevron.right")
        $0.image = image
        $0.tintColor = .systemGray
        return $0
    }(UIImageView())
    
    private(set) var cellType: ConfigType?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configTitle.text = nil
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.contentView.addSubview(configTitle)
        self.contentView.addSubview(chevronIcon)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            configTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            configTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            configTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24)
        ])
        
        NSLayoutConstraint.activate([
            chevronIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    private func configureViews() {
        contentView.backgroundColor = .systemGray4
    }
    
    func setupCell(title: String, type: ConfigType) {
        configTitle.text = title
        cellType = type
    }
}
