import UIKit

struct FullscreenPhotoConfigurator: FullscreenPhotoConfigurating {
    func configureFullscreenPhoto(for photo: Photo) -> UIViewController {
        let view = FullscreenPhotoViewController()
        let networking = FullscreenPhotoFetchingService()
        let interactor = FullscreenPhotoInteractor(networking: networking, imageURL: URL(string: photo.url)!)
        let presenter = FullscreenPhotoPresenter()

        view.output = interactor
        interactor.output = presenter
        presenter.output = view
        return view
    }
}
