import UIKit

protocol FullscreenPhotoNetworking {
    func fetchImageData(for url: URL) async throws -> Data
}

protocol FullscreenPhotoPresenting {
    func presentImageData(_ image: Data)
    func presentError(_ error: String)
}

typealias FullscreenPhotoInteractorOutput = FullscreenPhotoPresenting

final class FullscreenPhotoInteractor {
    var output: FullscreenPhotoInteractorOutput?
    private let imageURL: URL

    private let networking: FullscreenPhotoNetworking

    init(networking: FullscreenPhotoNetworking, imageURL: URL) {
        self.networking = networking
        self.imageURL = imageURL
    }
}

extension FullscreenPhotoInteractor: FullscreenPhotoInteracting {
    func onViewDidLoad() {
        Task { [weak self] in
            guard let self else { return }

            do {
                let imageData = try await networking.fetchImageData(for: imageURL)
                output?.presentImageData(imageData)
            } catch {
                output?.presentError(error.localizedDescription)
            }
        }
    }
}
