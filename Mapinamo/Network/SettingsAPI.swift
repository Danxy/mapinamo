import Foundation

class SettingsAPI: BasicAPI {
    public func getVersion( completion: @escaping (VersionModel?, Error?) -> Void) {
        get(path: "version",
            completionHandler: completion)
    }
}
