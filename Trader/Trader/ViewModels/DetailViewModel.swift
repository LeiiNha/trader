//
//  DetailViewModel.swift
//  Trader
//
//  Created by Erica Geraldes on 26/04/2023.
//

import Foundation
import Combine

protocol DetailViewModelProtocol {
    var companyDetailPublisher: AnyPublisher<Company, Never> { get }
    func fetchCompanyDetails()
}

final class DetailViewModel {
    typealias Services = HasNetworkService
    private let coordinator: Coordinator
    private let item: Datum
    private let services: Services
    private let companyDetailPassthrough: PassthroughSubject<Company, Never> = .init()
    private var subscriptions: Set<AnyCancellable> = .init()

    init(coordinator: Coordinator, item: Datum, services: Services) {
        self.coordinator = coordinator
        self.item = item
        self.services = services
    }
}

extension DetailViewModel: DetailViewModelProtocol {
    var companyDetailPublisher: AnyPublisher<Company, Never> {
        companyDetailPassthrough.eraseToAnyPublisher()
    }

    func fetchCompanyDetails() {
        services.networkService.fetchCompanyDetails(item.symbol)?
            .sink(receiveCompletion: { _ in }, receiveValue:  { [weak self] in self?.companyDetailPassthrough.send($0) })
            .store(in: &subscriptions)
    }
}
