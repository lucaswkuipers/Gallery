import UIKit

final class EmptyView: UIView {
    var action: (() -> Void)?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .secondaryLabel
        return label
    }()

    private let bottomButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBackground, for: .normal)
        button.setTitleColor(.systemBackground.withAlphaComponent(0.5), for: .highlighted)
        button.backgroundColor = UIColor.tintColor
        button.layer.cornerRadius = 20
        return button
    }()

    init() {
        super.init(frame: .zero)
        setupStyle()
        setupHierarchy()
        setupConstraints()
        setupActions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupData(
        systemImageName: String,
        title: String,
        subtitle: String,
        buttonTitle: String
    ) {
        imageView.image = UIImage(systemName: systemImageName)
        titleLabel.text = title
        subtitleLabel.text = subtitle
        bottomButton.setTitle(buttonTitle, for: .normal)
    }

    private func setupStyle() {
        backgroundColor = .systemBackground
    }

    private func setupHierarchy() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(bottomButton)
    }

    private func setupConstraints() {
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 64),
            imageView.heightAnchor.constraint(equalToConstant: 64),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            bottomButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            bottomButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomButton.widthAnchor.constraint(equalToConstant: 200),
            bottomButton.heightAnchor.constraint(equalToConstant: 50),
            bottomButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }

    private func setupActions() {
        bottomButton.addAction(
            UIAction { [weak self] _ in
                self?.action?()
            },
            for: .touchUpInside
        )
    }
}

#Preview {
    EmptyView()
}
