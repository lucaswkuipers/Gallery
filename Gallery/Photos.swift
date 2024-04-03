import Foundation

// MARK: - Photos
struct Photos: Equatable, Codable {
    let photos: [Photo]
    let nextPage: String
}

// MARK: - Photo
struct Photo: Equatable, Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}
