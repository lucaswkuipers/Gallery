import UIKit

final class PhotoCell: UITableViewCell {
    static let size = 100.0
    static let padding = 16.0
    static var height: Double { size + padding }

    private var currentImageTask: Task<(), Never>?
    private var photo: Photo?

    private let photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
        setupHierarchy()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        currentImageTask?.cancel()
        photoView.image = nil
    }

    func setupData(for photo: Photo) {
        self.photo = photo
        titleLabel.text = photo.title
        currentImageTask = Task { [weak self] in
            guard let self else {
                return
            }

            guard let url = URL(string: photo.thumbnailURL) else {
                // Invalid url
                return
            }

            guard let (data, _) = try? await URLSession.shared.data(from: url) else {
                // Task cancelled
                return
            }
            let image = UIImage(data: data)
            photoView.image = image
        }
    }

    private func setupStyle() {
        selectionStyle = .none
        contentView.backgroundColor = .systemBackground
    }

    private func setupHierarchy() {
        contentView.addSubview(photoView)
        contentView.addSubview(titleLabel)
    }

    private func setupConstraints() {
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: Self.height),
            photoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.padding),
            photoView.heightAnchor.constraint(equalToConstant: Self.size),
            photoView.widthAnchor.constraint(equalToConstant: Self.size),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: Self.padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.padding)
        ])
    }
}

#if DEBUG
extension PhotoCell {
    fileprivate convenience init(photo: Photo) {
        self.init(style: .default, reuseIdentifier: nil)
        self.photo = photo
        setupData(for: photo)
    }
}

private extension Photo {
    static let sample = Photo(
        albumID: 123,
        id: 123,
        title: "accusamus beatae ad facilis cum similique qui sunt",
        url: "https://via.placeholder.com/600/92c952",
        thumbnailURL: "https://via.placeholder.com/150/92c952"
    )
}

#Preview {
    PhotoCell(photo: .sample)
}
#endif

