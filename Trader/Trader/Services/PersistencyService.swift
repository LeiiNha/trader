//
//  PersistencyService.swift
//  Trader
//
//  Created by Erica Geraldes on 27/04/2023.
//

import Foundation

enum PersistencyKey: String {
    case datum = "Datum.json"
}

protocol PersistencyServiceProtocol {
    func saveData<T: Encodable>(data: T, forKey: PersistencyKey)
    func loadData<T: Decodable>(type: T.Type, forKey: PersistencyKey) -> T?
}

final class PersistencyService {}

extension PersistencyService: PersistencyServiceProtocol {
    func saveData<T: Encodable>(data: T, forKey: PersistencyKey) {
        guard let url = FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?.appendingPathComponent(forKey.rawValue, isDirectory: false) else { return }

        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(data)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
    }

    func loadData<T: Decodable>(type: T.Type, forKey: PersistencyKey) -> T? {
        guard let url = FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?.appendingPathComponent(forKey.rawValue, isDirectory: false) else { return nil }

        if !FileManager.default.fileExists(atPath: url.path) {
            return nil
        }

        if let data = FileManager.default.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                print("Error decoding file in cache")
                return nil
            }
        } else {
            print("No data at \(url.path)!")
            return nil
        }
    }
}
