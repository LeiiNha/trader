//
//  Company.swift
//  Trader
//
//  Created by Erica Geraldes on 26/04/2023.
//

import Foundation

struct Company: Codable {
    let country, currency, estimateCurrency, exchange: String
    let finnhubIndustry, ipo: String
    let logo: String
    let marketCapitalization: Double
    let name, phone: String
    let shareOutstanding: Int
    let ticker: String
    let weburl: String
}
