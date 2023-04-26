//
//  Symbol.swift
//  Trader
//
//  Created by Erica Geraldes on 26/04/2023.
//

import Foundation

struct Symbol: Codable {
    let currency, description, displaySymbol, figi: String
    let mic, shareClassFIGI, symbol, symbol2: String
    let type: String
}
