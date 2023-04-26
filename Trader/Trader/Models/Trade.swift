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
struct Datum: Codable {
    let tradeCondition: [String]
    let lastPrice: Double
    let symbol: String
    let timestamp: Int
    let volume: Int

    enum CodingKeys: String, CodingKey {
        case tradeCondition = "c"
        case lastPrice = "p"
        case symbol = "s"
        case timestamp = "t"
        case volume = "v"
    }
}
