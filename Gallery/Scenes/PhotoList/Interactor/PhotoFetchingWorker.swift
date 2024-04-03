import Foundation

final class PhotoFetchingWorker: PhotoFetching {
    private let endpoint = URL(string: "https://firebasestorage.googleapis.com/v0/b/amo-tech-interview.appspot.com/o/page-1.json?alt=media&token=98dc4412-495f-4e51-91d8-24f230d98481")!

    func fetchPhotos() async -> Result<Photos, PhotoListError> {
        do {
            let (data, _) = try await URLSession.shared.data(from: endpoint)
            let photos = try JSONDecoder().decode(Photos.self, from: data)
            return .success(photos)
        } catch {
            if let error = error as NSError?,
               error.domain == NSURLErrorDomain,
               error.code == NSURLErrorNotConnectedToInternet {
                return .failure(.noConnection)
            }

            return .failure(.generic)
        }
    }
}
