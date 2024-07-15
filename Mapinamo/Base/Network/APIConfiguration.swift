import Foundation

public class APIConfiguration {
    public static let defaultConfiguration = APIConfiguration()
    
    public var baseUrl: String!
    
    public var decoder: JSONDecoder!
    
    public var encoder: JSONEncoder!
}
