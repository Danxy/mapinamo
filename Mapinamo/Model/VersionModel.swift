import Foundation

struct VersionModel: Codable {
    let data: VersionDetailsModel
}

struct VersionDetailsModel: Codable {
    let version: Int
}
