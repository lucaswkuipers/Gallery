enum PhotoListError: Error {
    case noConnection
    case generic
}

protocol PhotoListDisplaying: AnyObject {
    func displayPhotos(_ photos: [Photo])
    func displayError(systemImageName: String, title: String, subtitle: String, actionTitle: String)
}

extension PhotoListError {
    var systemImageName: String {
        switch self {
        case .noConnection:
            return "network.slash"
        case .generic:
            return "minus.circle.fill"
        }
    }

    var title: String {
        switch self {
        case .noConnection:
            return "No connection"
        case .generic:
            return "Something went wrong"
        }
    }

    var subtitle: String {
        switch self {
        case .noConnection:
            return "The internet connection appears to be offline."
        case .generic:
            return "Pease try again."
        }
    }

    var action: String {
        switch self {
        case .noConnection, .generic:
            return "Try again"
        }
    }
}

typealias PhotoListPresenterOutput = PhotoListDisplaying

final class PhotoListPresenter {
    weak var output: PhotoListPresenterOutput?
}

extension PhotoListPresenter: PhotoListPresenting {
    func presentPhotosResult(_ result: Result<Photos, PhotoListError>) {
        switch result {
        case .success(let photos):
            output?.displayPhotos(photos.photos)
        case .failure(let error):
            output?.displayError(systemImageName: error.systemImageName, title: error.title, subtitle: error.subtitle, actionTitle: error.action)
        }
    }
}

