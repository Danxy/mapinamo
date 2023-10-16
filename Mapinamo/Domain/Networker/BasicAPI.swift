//
//  BasicAPI.swift
//  Mapinamo
//
//  Created by Daniel on 2023-10-12.
//

import Foundation

public class BasicAPI {
    let configuration: APIConfiguration
    
    public init(configuration: APIConfiguration) {
        self.configuration = configuration
    }
    
    func endpoint(_ endpoint: String) -> String {
        return configuration.baseUrl + endpoint
    }
}

extension BasicAPI {
    public convenience init() {
        self.init(configuration: APIConfiguration.defaultConfiguration)
    }
}
