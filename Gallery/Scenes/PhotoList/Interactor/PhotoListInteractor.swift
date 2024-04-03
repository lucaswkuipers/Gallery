protocol PhotoFetching {
    func fetchPhotos() async -> Result<Photos, PhotoListError>
}

protocol PhotoListPresenting {
    func presentPhotosResult(_ result: Result<Photos, PhotoListError>)
}

typealias PhotoListInteractorOutput = PhotoListPresenting

import Foundation

final class PhotoListInteractor {
    var output: PhotoListInteractorOutput?
    var nextPage: URL?

    private let worker: PhotoFetching

    init(worker: PhotoFetching) {
        self.worker = worker
    }
}

extension PhotoListInteractor: PhotoListInteracting {
    func onReachBottom() {
        // ... fetch next page
        print("Fetching next page...")
    }
    
    func onViewDidLoad() {
        fetchPhotos()
    }

    func onTapTryAgain() {
        fetchPhotos()
    }

    private func fetchPhotos() {
        Task {
            let result = await worker.fetchPhotos()

            switch result {
            case .success(let success):
                nextPage = URL(string: success.nextPage)
            case .failure:
                break
            }

            output?.presentPhotosResult(result)
        }
    }
}
