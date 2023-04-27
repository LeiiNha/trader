//
//  DefaultCoordinator.swift
//  Trader
//
//  Created by Erica Geraldes on 26/04/2023.
//

import UIKit

fileprivate let services = Services()

final class AppCoordinator {
    weak var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let viewController = MainViewController()
        let rootViewController = UINavigationController(rootViewController: viewController)
        let coordinator =  MainCoordinator(viewController: rootViewController)
        let viewModel = MainViewModel(coordinator: coordinator, services: services)
        viewController.viewModel = viewModel
        window?.rootViewController = rootViewController
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
}

protocol Coordinator {
    var viewController: UIViewController { get }

    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?)

    func dismiss(animated: Bool, completion: (() -> Void)?)

    func dismissPresentedViewController(animated: Bool, completion: (() -> Void)?)
}

protocol MainCoordinatorProtocol: Coordinator {
    func presentDetailedViewController(_ item: Datum)
}

final class MainCoordinator: MainCoordinatorProtocol {
    private(set) var viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        viewController.present(viewControllerToPresent, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        viewController.dismiss(animated: animated, completion: completion)
    }

    func dismissPresentedViewController(animated: Bool, completion: (() -> Void)?) {
        guard viewController.presentedViewController?.isBeingDismissed == false else {
            completion?()
            return
        }
        viewController.dismiss(animated: animated, completion: completion)
    }

    func presentDetailedViewController(_ item: Datum) {
        let viewController = DetailViewController()
        viewController.modalPresentationStyle = .popover
        viewController.viewModel = DetailViewModel(coordinator: MainCoordinator(viewController: viewController),
                                                   item: item,
                                                   services: services)
        present(viewController, animated: true, completion: nil)
    }
}

