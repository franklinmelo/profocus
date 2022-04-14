import Foundation
import UIKit

final class CategoriesCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        configureViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    private func setupViews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(chevronIcon)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24)
        ])
        
        NSLayoutConstraint.activate([
            chevronIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])

    }
    
    private func configureViews() {
        contentView.backgroundColor = .systemGray4
    }
    
    func setTitle(with text: String) {
        titleLabel.text = text
    }
}
