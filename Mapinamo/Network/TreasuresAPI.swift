import Foundation

class TreasuresAPI: BasicAPI {
    
    public func createTreasure(body: TreasureRequest, completion: @escaping (TreasureResponse?, Error?) -> Void) {
        post(path: "v0/treasures",
             body: body,
             headers: nil,
             completionHandler: completion)
    }
    
    public func uploadImage(_ imageData: Data, id: CLongLong, completion: @escaping (Bool, Error?)->Void) {
        uploadMultipartData(path: "v0/treasures/\(id.description)/images", data: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "image", fileName: "image_file.png", mimeType: "image/png")
        }, completionHandler: completion)
    }
    
    public func getTreasures(latitude: CLong,
                             longitude: CLong,
                             completion: @escaping (TreasuresResponse?, Error?) -> Void) {
        get(path: "v0/treasures",
            parameters:["latitude": latitude,
                        "longitude": longitude],
            completionHandler: completion)
    }
    
    public func getTreasure(_ id: CLongLong,
                            completion: @escaping (TreasureResponse?, Error?) -> Void) {
        get(path: "v0/treasures/\(id.description)",
            completionHandler: completion)
    }
    
    public func getTreasureImages(_ id: CLongLong,
                                  completion: @escaping (TreasureImages?, Error?) -> Void) {
        get(path: "v0/treasures/\(id.description)/images",
            completionHandler: completion)
        
    }
    
    public func pickupTreasure(_ id: CLongLong, completion: @escaping (Bool, Error?) -> Void)  {
        post(path: "v0/treasures/\(id.description)/pick",
             headers: nil,
             completionHandler: completion)
    }
}
