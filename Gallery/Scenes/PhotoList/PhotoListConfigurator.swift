import UIKit

struct PhotoListConfigurator: PhotoListConfigurating {
    func configurePhotoList(_ router: PhotoListRouting) -> UIViewController {
        let view = PhotoListViewController()
        let worker = PhotoFetchingWorker()
        let interactor = PhotoListInteractor(worker: worker)
        let presenter = PhotoListPresenter()

        view.output = interactor
        view.router = router
        interactor.output = presenter
        presenter.output = view

        return view
    }
}
