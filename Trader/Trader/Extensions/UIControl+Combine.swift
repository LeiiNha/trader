//
//  UIControl+Combine.swift
//  Trader
//
//  Created by Erica Geraldes on 26/04/2023.
//

import Combine
import UIKit

struct UIControlPublisher<Control: UIControl>: Publisher {
    typealias Output = Control
    typealias Failure = Never

    private let control: Control
    private let event: UIControl.Event

    init(control: Control, event: UIControl.Event) {
        self.control = control
        self.event = event
    }

    func receive<S>(subscriber: S) where S: Subscriber, S.Failure == UIControlPublisher.Failure, S.Input == UIControlPublisher.Output {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: event)
        subscriber.receive(subscription: subscription)
    }
}

private final class UIControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control

    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_ demand: Subscribers.Demand) { }

    func cancel() {
        subscriber = nil
    }

    @objc
    private func eventHandler() {
        _ = subscriber?.receive(control)
    }
}

protocol CombineCompatible { }
extension UIControl: CombineCompatible { }
extension CombineCompatible where Self: UIControl {
    func publisher(for event: UIControl.Event) -> UIControlPublisher<UIControl> {
        .init(control: self, event: event)
    }
}


