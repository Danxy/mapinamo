//
//  VersionModel.swift
//  Mapinamo
//
//  Created by Daniel on 2023-10-12.
//

import Foundation

struct VersionModel: Codable {
    let data: VersionDetailsModel
}

struct VersionDetailsModel: Codable {
    let version: Int
}
