import UIKit

protocol FullscreenPhotoDisplaying {
    func displayPhoto(_ image: UIImage)
    func displayError(_ error: String)
}

typealias FullscreenPhotoPresenterOutput = FullscreenPhotoDisplaying

final class FullscreenPhotoPresenter {
    var output: FullscreenPhotoPresenterOutput?
}

extension FullscreenPhotoPresenter: FullscreenPhotoPresenting {
    func presentImageData(_ imageData: Data) {
        guard let image = UIImage(data: imageData) else {
            return
        }
        output?.displayPhoto(image)
    }

    func presentError(_ error: String) {
        output?.displayError(error)
    }
}
