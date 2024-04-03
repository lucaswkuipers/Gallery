import UIKit

final class FullscreenPhotoFetchingService: FullscreenPhotoNetworking {
    func fetchImageData(for url: URL) async throws -> Data {
        try await URLSession.shared.data(from: url).0
    }
}
