//
//  Services.swift
//  Trader
//
//  Created by Erica Geraldes on 27/04/2023.
//

import Foundation

protocol HasNetworkService {
    var networkService: NetworkServiceProtocol { get }
}

protocol HasReachabilityService {
    var reachabilityService: ReachabilityServiceProtocol { get }
}

protocol HasPersistencyService {
    var persistencyService: PersistencyServiceProtocol { get }
}

final class Services: HasNetworkService, HasReachabilityService, HasPersistencyService {
    var networkService: NetworkServiceProtocol = NetworkService()
    var reachabilityService: ReachabilityServiceProtocol = ReachabilityService()
    var persistencyService: PersistencyServiceProtocol = PersistencyService()
}

