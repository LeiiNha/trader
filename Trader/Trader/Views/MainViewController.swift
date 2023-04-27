//
//  MainViewController.swift
//  Trader
//
//  Created by Erica Geraldes on 26/04/2023.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, Datum>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Datum>
    private var dataSource: DataSource?
    private var tableView: UITableView?
    private var connectionView = UIView()
    private var subscriptions: Set<AnyCancellable> = .init()
    
    var viewModel: MainViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
        configureConnectionView()
        configureDataSource([])
        configureSubscriptions()
    }

    private func configureConnectionView() {
        view.addSubview(connectionView)
        connectionView.alpha = 0
        connectionView.translatesAutoresizingMaskIntoConstraints = false
        connectionView.backgroundColor = .red
        let label = UILabel()
        label.text = "No connection found"
        label.textColor = .white
        connectionView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: connectionView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: connectionView.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            connectionView.topAnchor.constraint(equalTo: view.topAnchor),
            connectionView.heightAnchor.constraint(equalToConstant: 100.0),
            connectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            connectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        guard let tableView = self.tableView else { return }
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        view.addSubview(tableView)
    }

    private func configureDataSource(_ items: [Datum]) {
        guard let tableView = tableView else { return }
        dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, itemIdentifier) -> MainTableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier,
                                                     for: indexPath) as? MainTableViewCell
            cell?.configure(itemIdentifier)
            return cell
        })

        var snapshot = DataSourceSnapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(items)

        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func configureSubscriptions() {
        viewModel
            .itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in self?.configureDataSource(items) }
            .store(in: &subscriptions)

        viewModel
            .connectionIssuePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.showHideConnectionView($0)
            }
            .store(in: &subscriptions)
    }

    private func showHideConnectionView(_ show: Bool) {
        connectionView.alpha = show ? 1 : 0
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        viewModel.didSelect(item)
    }
}

extension MainViewController {
    enum Section: Hashable {
        case main
    }
}
