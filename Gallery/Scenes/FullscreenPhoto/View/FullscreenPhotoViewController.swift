import UIKit

protocol FullscreenPhotoInteracting {
    func onViewDidLoad()
}

typealias FullscreenPhotoOutput = FullscreenPhotoInteracting

final class FullscreenPhotoViewController: UIViewController {
    var output: FullscreenPhotoOutput?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let errorView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .red
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        output?.onViewDidLoad()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground

        view.addSubview(imageView)
        view.addSubview(errorView)

        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension FullscreenPhotoViewController: FullscreenPhotoDisplaying {
    func displayPhoto(_ image: UIImage) {
        DispatchQueue.main.async { [unowned self] in
            imageView.image = image
            errorView.isHidden = true
            imageView.isHidden = false
        }
    }

    func displayError(_ error: String) {
        DispatchQueue.main.async { [unowned self] in
            errorView.isHidden = false
            imageView.isHidden = true
        }
    }
}

