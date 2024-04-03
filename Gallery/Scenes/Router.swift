import UIKit

protocol PhotoListConfigurating {
    func configurePhotoList(_ router: PhotoListRouting) -> UIViewController
}

protocol FullscreenPhotoConfigurating {
    func configureFullscreenPhoto(for photo: Photo) -> UIViewController
}

final class Router {
    let navigationController: UINavigationController
    let photoListConfigurator: PhotoListConfigurating
    let fullscreenPhotoConfigurator: FullscreenPhotoConfigurating

    init(
        navigationController: UINavigationController = UINavigationController(),
        photoListConfigurator: PhotoListConfigurating,
        fullscreenPhotoConfigurator: FullscreenPhotoConfigurating
    ) {
        self.navigationController = navigationController
        self.photoListConfigurator = photoListConfigurator
        self.fullscreenPhotoConfigurator = fullscreenPhotoConfigurator
    }
}

extension Router {
    func start() -> UIViewController {
        showPhotoList()
        return navigationController
    }

    func showPhotoList() {
        let viewController = photoListConfigurator.configurePhotoList(self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension Router: PhotoListRouting {
    func showFullscreen(for photo: Photo) {
        let viewController = fullscreenPhotoConfigurator.configureFullscreenPhoto(for: photo)
        navigationController.pushViewController(viewController, animated: true)
    }
}
