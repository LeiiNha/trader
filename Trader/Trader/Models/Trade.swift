//
//  Trade.swift
//  Trader
//
//  Created by Erica Geraldes on 26/04/2023.
//

import Foundation

struct Trade: Codable {
    let data: [Datum]
    let type: String
}

// MARK: - Datum
struct Datum: Codable, Hashable {
    let uuid = UUID()
    let tradeCondition: [String]
    let lastPrice: Double
    let symbol: String
    let timestamp: Int
    let volume: Int
    var difference: Difference = .equal
    var differenceValue: Double = 0

    enum CodingKeys: String, CodingKey {
        case tradeCondition = "c"
        case lastPrice = "p"
        case symbol = "s"
        case timestamp = "t"
        case volume = "v"
    }

    enum Difference {
        case up
        case down
        case equal
    }
}

//extension Datum: Hashable {
//    static func ==(lhs: Datum, rhs: Datum) -> Bool {
//        return lhs.uuid == rhs.uuid
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(uuid)
//    }
//}
