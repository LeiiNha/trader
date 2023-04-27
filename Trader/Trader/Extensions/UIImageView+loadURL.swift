//
//  UIImageView+loadURL.swift
//  Trader
//
//  Created by Erica Geraldes on 27/04/2023.
//

import UIKit
import WebKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
