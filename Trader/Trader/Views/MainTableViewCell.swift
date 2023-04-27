//
//  MainTableViewCell.swift
//  Trader
//
//  Created by Erica Geraldes on 27/04/2023.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    static let identifier = "MainTableViewCell"

    private var symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()

    private var differenceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLabels() {
        addSubview(symbolLabel)
        addSubview(priceLabel)
        addSubview(differenceLabel)
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        differenceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            symbolLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            symbolLabel.heightAnchor.constraint(equalToConstant: 30),
            symbolLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            priceLabel.heightAnchor.constraint(equalToConstant: 30),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            differenceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            differenceLabel.heightAnchor.constraint(equalToConstant: 30),
            differenceLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 15)
        ])
    }

    func configure(_ item: Datum) {
        symbolLabel.text = item.symbol
        priceLabel.text = String(item.lastPrice)
        differenceLabel.text = String(item.differenceValue)
        switch item.difference {
        case .down:
            priceLabel.textColor = .red
            differenceLabel.textColor = .red
        case .up:
            priceLabel.textColor = .green
            differenceLabel.textColor = .green
        case .equal:
            priceLabel.textColor = .black
            differenceLabel.textColor = .black
        }
    }

}
