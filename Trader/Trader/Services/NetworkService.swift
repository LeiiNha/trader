//
//  NetworkService.swift
//  Trader
//
//  Created by Erica Geraldes on 26/04/2023.
//

import Foundation
import Combine

enum RequestError: Error {
    case decodeFail
    case requestFailed
}

protocol NetworkServiceProtocol {
    var subscribedTraderPublisher: AnyPublisher<[Datum], Never> { get }
    func fetchCompanyDetails(_ company: String) -> AnyPublisher<Company, RequestError>?
    func connectWebsocket()
    func disconnectWebsocket()
}

final class NetworkService: NSObject {
    private let API_KEY = "ch4fp7pr01qlenl61s1gch4fp7pr01qlenl61s20"
    private let BASE_URL = "https://finnhub.io/api/v1"
    private var webSocket: URLSessionWebSocketTask?
    private var subscriptions: Set<AnyCancellable> = .init()
    private var subscribedTraderPassthrough: PassthroughSubject<[Datum], Never> = .init()

    // TODO: IMPROVE
    func receive(){
      guard let webSocket = webSocket else { return }
          let workItem = DispatchWorkItem { [weak self] in
             webSocket.receive(completionHandler: { result in

                  switch result {
                  case .success(let message):
                      switch message {
                      case .string(let strMessgae):
                      print("String received \(strMessgae)")
                          let jsonData = Data(strMessgae.utf8)
                          if let trade = try? JSONDecoder().decode(Trade.self, from: jsonData) {
                              self?.subscribedTraderPassthrough.send(trade.data)
                          }
                      default:
                          break
                      }
                  case .failure(let error):
                      print("Error Receiving \(error)")
                  }
                  self?.receive()
              })
          }
        DispatchQueue.global().asyncAfter(deadline: .now() + 1 , execute: workItem)
      }

    // TODO: ADD QUERYITEM
    func fetchStockList() {
        guard let url = URL(string: "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=\(API_KEY)") else { return }
        connectWebsocket()

        URLSession
             .shared
             .dataTaskPublisher(for: url)
             .mapError { _ in return RequestError.requestFailed }
             .map(\.data)
             .decode(type: [Symbol].self, decoder: JSONDecoder())
             .mapError { _ in return RequestError.decodeFail }
             .eraseToAnyPublisher()
             .sink(receiveCompletion: { _ in},
                   receiveValue: { [weak self] symbolsList in
                 Array(symbolsList.prefix(5)).forEach { self?.subscribeToSymbol($0.symbol) }
             })
             .store(in: &subscriptions)
    }

    //TODO: IMPROVE
    func subscribeToSymbol(_ symbol: String) {
        let jsonToSend = """
        {"type":"subscribe","symbol":"\(symbol)"}
        """

        webSocket?.send(.string(jsonToSend), completionHandler: { error in
            if let error = error {
                print(error)
            }
        })
    }
}

extension NetworkService: NetworkServiceProtocol {
    var subscribedTraderPublisher: AnyPublisher<[Datum], Never> {
        subscribedTraderPassthrough.eraseToAnyPublisher()
    }

    func disconnectWebsocket() {
        webSocket?.cancel(with: .goingAway, reason: "Connection closed".data(using: .utf8))
    }

    // TODO: ADD QUERYITEM
    func connectWebsocket() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string:  "wss://ws.finnhub.io?token=\(API_KEY)")

        webSocket = session.webSocketTask(with: url!)
        webSocket?.resume()
    }

    func fetchCompanyDetails(_ company: String) -> AnyPublisher<Company, RequestError>? {
        guard let url = URL(string: "") else { return nil }

        return URLSession
             .shared
             .dataTaskPublisher(for: url)
             .mapError { _ in return RequestError.requestFailed }
             .map(\.data)
             .decode(type: Company.self, decoder: JSONDecoder())
             .mapError { _ in return RequestError.decodeFail }
             .eraseToAnyPublisher()
        
    }
}

extension NetworkService: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Connected to server")
        self.receive()
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Disconnect from Server \(String(describing: reason))")
        webSocket = nil
    }
}
