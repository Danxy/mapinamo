//
//  APIConfiguration.swift
//  Mapinamo
//
//  Created by Daniel on 2023-10-12.
//

import Foundation

public class APIConfiguration {
    public static let defaultConfiguration = APIConfiguration()
    
    public var baseUrl: String!
    
    public var decoder: JSONDecoder!
    
    public var encoder: JSONEncoder!
}
