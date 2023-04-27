//
//  DetailViewController.swift
//  Trader
//
//  Created by Erica Geraldes on 26/04/2023.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    var viewModel: DetailViewModelProtocol!
    private var subscriptions: Set<AnyCancellable> = .init()

    private var imageView = UIImageView()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        return label
    }()

    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private var sectorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()

    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureSubviews()
        configureSubscriptions()
        viewModel.fetchCompanyDetails()
    }

    private func configureSubscriptions() {
        viewModel.companyDetailPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.configure($0) }
            .store(in: &subscriptions)
    }

    private func configure(_ company: Company) {
        if let url = URL(string: company.logo) {
            // Image comes in svg
            imageView.load(url: url)
        }
        titleLabel.text = company.name
        subtitleLabel.text = company.ticker
        sectorLabel.text = company.finnhubIndustry
        priceLabel.text = company.currency
    }

    private func configureSubviews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(sectorLabel)
        view.addSubview(priceLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        sectorLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150.0)
        ])

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            sectorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sectorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            subtitleLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor)
        ])
    }
}
