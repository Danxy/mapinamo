//
//  TreasureModel.swift
//  Mapinamo
//
//  Created by Daniel on 2023-10-12.
//

import Foundation

struct TreasureRequest: Codable {
    var date: CLongLong
    var isPrivate: Bool
    var type: String
    var comment: String
    var name: String
    var latitude: CLong
    var longitude: CLong
    var altitude: CLong
}

struct TreasureResponse: Codable {
    let data: TreasureData
}

struct TreasuresResponse: Codable {
    let data: [TreasureData]
}

struct TreasureData: Codable {
    let id: CLongLong
    let date: CLongLong
    let isPrivate: Bool
    let type: String?
    let comment: String?
    let name: String?
    let createdAt: String
    let updatedAt: String
    let picked: Bool?
    let coords: Coords?
}

struct Coords: Codable {
    let id: CLongLong?
    let treasureId: CLongLong?
    let latitude: CLong
    let longitude: CLong
    let altitude: CLong?
    let createdAt: String
    let updatedAt: String
}

struct TreasureImages: Codable {
    let data: [String]?
}

struct CategoryData: Equatable, Codable {
    let categoryTitle: String
    let size: Int
}

