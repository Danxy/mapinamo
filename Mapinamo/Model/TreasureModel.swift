import Foundation

enum TreasureCategory: String, CaseIterable {
    case other       = "Other"
    case bloodDonation   = "🩸 blood donation"
    case manpower     = "💪 manpower"
    case soldiersGoods  = "🧦 goods for soldiers"
    case familiesGoods     = "👨‍👩‍👦‍👦 goods for families"
    case food       = "🍲 home food"
    case drivers       = "🚛 drivers"
}

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
    
    var categoty: TreasureCategory {
        if type?.lowercased() == "🍲 home food" {
            return .food
        } else if type?.lowercased() == "🩸 blood donation" {
            return .bloodDonation
        } else if type?.lowercased() == "💪 manpower" {
            return .manpower
        } else if type?.lowercased() ==  "🧦 goods for soldiers" {
            return .soldiersGoods
        } else if type?.lowercased() == "👨‍👩‍👦‍👦 goods for families" || type?.lowercased() == "👨‍👩‍👧‍👦 goods for families" {
            return .familiesGoods
        } else if type?.lowercased() == "🍲 home food" {
            return .food
        } else if type?.lowercased() == "🚛 drivers" {
            return .drivers
        }
        return .other
    }
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
    var categoty: TreasureCategory {
        if categoryTitle.lowercased() == "🍲 home food" {
            return .food
        } else if categoryTitle.lowercased() == "🩸 blood donation" {
            return .bloodDonation
        } else if categoryTitle.lowercased() == "💪 manpower" {
            return .manpower
        } else if categoryTitle.lowercased() ==  "🧦 goods for soldiers" {
            return .soldiersGoods
        } else if categoryTitle.lowercased() == "👨‍👩‍👦‍👦 goods for families" || categoryTitle.lowercased() == "👨‍👩‍👧‍👦 goods for families" {
            return .familiesGoods
        } else if categoryTitle.lowercased() == "🍲 home food" {
            return .food
        } else if categoryTitle.lowercased() == "🚛 drivers" {
            return .drivers
        }
        return .other
    }
}

