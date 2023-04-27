//
//  MainViewModel.swift
//  Trader
//
//  Created by Erica Geraldes on 26/04/2023.
//

import Foundation
import Combine

protocol MainViewModelProtocol {
    var itemsPublisher: AnyPublisher<[Datum], Never> { get }
    var connectionIssuePublisher: AnyPublisher<Bool, Never> { get }
    func didSelect(_ item: Datum)
}

final class MainViewModel {
    typealias Services = HasNetworkService & HasReachabilityService & HasPersistencyService
    private let coordinator: MainCoordinatorProtocol
    private let services: Services

    private var itemsCurrentState: CurrentValueSubject<[Datum], Never> = .init([])
    private var connectionIssuePassthrough: PassthroughSubject<Bool, Never> = .init()
    private var subscriptions: Set<AnyCancellable> = .init()

    init(coordinator: MainCoordinatorProtocol, services: Services) {
        self.coordinator = coordinator
        self.services = services

        configureSubscriptions()
        getLocalData()
        getStocks()
    }

    private func getLocalData() {
        if let teste = services.persistencyService.loadData(type: [Datum].self, forKey: .datum) {
            itemsCurrentState.send(teste)
        }
    }

    private func configureSubscriptions() {
        services
            .networkService
            .subscribedTraderPublisher
            .sink { [weak self] items in
                self?.itemsCurrentState.send(items)
                if items.count > 0 {
                    self?.services.persistencyService.saveData(data: items, forKey: .datum)
                }
            }
            .store(in: &subscriptions)
        
        services
            .reachabilityService
            .connectionUpdatedPublisher
            .last()
            .sink { [weak self] in
                if $0 == .satisfied {
                    self?.getStocks()
                }
                self?.connectionIssuePassthrough.send($0 != .satisfied)

            }
            .store(in: &subscriptions)
    }

    private func getStocks() {
        services.networkService.connectWebsocket()
        services.networkService.subscribeToStocks()
    }
}

extension MainViewModel: MainViewModelProtocol {
    var connectionIssuePublisher: AnyPublisher<Bool, Never> {
        connectionIssuePassthrough.eraseToAnyPublisher()
    }

    var itemsPublisher: AnyPublisher<[Datum], Never> {
        itemsCurrentState.eraseToAnyPublisher()
    }

    func didSelect(_ item: Datum) {
        coordinator.presentDetailedViewController(item)
    }
}
