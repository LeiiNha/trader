//
//  ReachabilityService.swift
//  Trader
//
//  Created by Erica Geraldes on 27/04/2023.
//

import Foundation
import Network
import Combine

enum ConnectionStatus {
    case satisfied
    case unsatisfied
    case requiresConnection
}

protocol ReachabilityServiceProtocol {
    var connectionUpdatedPublisher: AnyPublisher<ConnectionStatus, Never> { get }
}

final class ReachabilityService {
    private let pathMonitor: NWPathMonitor = NWPathMonitor()
    private let backgroudQueue = DispatchQueue.global(qos: .background)
    private var connectionUpdatedPassthrough: CurrentValueSubject<ConnectionStatus, Never> = .init(.unsatisfied)

    private lazy var pathUpdateHandler: ((NWPath) -> Void) = { [weak self] path in
        if path.status == NWPath.Status.satisfied {
            self?.connectionUpdatedPassthrough.send(.satisfied)
        } else if path.status == NWPath.Status.unsatisfied {
            self?.connectionUpdatedPassthrough.send(.unsatisfied)
        } else if path.status == NWPath.Status.requiresConnection {
            self?.connectionUpdatedPassthrough.send(.requiresConnection)
        }
    }

    init() {
        pathMonitor.pathUpdateHandler = self.pathUpdateHandler
        pathMonitor.start(queue: backgroudQueue)
    }
}

extension ReachabilityService: ReachabilityServiceProtocol {
    var connectionUpdatedPublisher: AnyPublisher<ConnectionStatus, Never> {
        connectionUpdatedPassthrough.eraseToAnyPublisher()
    }
}
