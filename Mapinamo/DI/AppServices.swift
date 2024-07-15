import Foundation

extension AppDelegate {
    
    func initDIServices() {
        DIContainer.shared.register(forClass: APIConfiguration.self, type: .factory) { _ in
            let configuration = APIConfiguration()
            
            configuration.baseUrl = "https://api.mapinamo.com/api/"
            configuration.encoder = JSONEncoder()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            configuration.decoder = decoder
            configuration.encoder = encoder
            return configuration
        }
        
        DIContainer.shared.register(forClass: TreasuresAPI.self, type: .singleton) { container in
            TreasuresAPI(configuration: container.provide(ofClass: APIConfiguration.self))
        }
        
        DIContainer.shared.register(forClass: SettingsAPI.self, type: .singleton) { container in
            SettingsAPI(configuration: container.provide(ofClass: APIConfiguration.self))
        }
    }
}
