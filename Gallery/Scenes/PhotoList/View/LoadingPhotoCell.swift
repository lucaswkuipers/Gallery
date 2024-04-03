import UIKit

final class LoadingPhotoCell: UITableViewCell {
    static let size = 100.0
    static let padding = 16.0
    static var height: Double { size + padding }

    private static let startColor: UIColor = .gray.withAlphaComponent(0.5)
    private static let endColor: UIColor = .lightGray.withAlphaComponent(0.5)

    private let photoView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        return view
    }()

    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
        setupHierarchy()
        setupConstraints()
        setupAnimations()
        NotificationCenter.default.addObserver(self, selector: #selector(setupAnimations), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        selectionStyle = .none
        backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground
    }

    private func setupHierarchy() {
        contentView.addSubview(photoView)
        contentView.addSubview(titleStackView)

        let paddings = [0, 0, 100.0]

        for padding in paddings {
            let titleView = makeTitleView()
            titleStackView.addArrangedSubview(titleView)
            titleView.translatesAutoresizingMaskIntoConstraints = false
            titleView.trailingAnchor.constraint(equalTo: titleStackView.trailingAnchor, constant: -padding).isActive = true
        }
    }

    private func setupConstraints() {
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: Self.height),
            photoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.padding),
            photoView.heightAnchor.constraint(equalToConstant: Self.size),
            photoView.widthAnchor.constraint(equalToConstant: Self.size),
            titleStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: Self.padding),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.padding)
        ])
    }

    @objc private func setupAnimations() {
        UIView.animate(
            withDuration: 0.8,
            delay: 0.0,
            options: [.autoreverse, .repeat])
        { [unowned self] in
            photoView.backgroundColor = Self.startColor
            titleStackView.arrangedSubviews.forEach {
                $0.backgroundColor = Self.startColor
            }
        } completion: { [unowned self] _ in
            photoView.backgroundColor = Self.endColor
            titleStackView.arrangedSubviews.forEach {
                $0.backgroundColor = Self.endColor
            }
        }
    }

    private func makeTitleView() -> UIView {
        let view = UIView()
        view.backgroundColor = LoadingPhotoCell.startColor
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return view
    }
}

#Preview {
    LoadingPhotoCell()
}

