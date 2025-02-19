//
//  EventPublisher.swift
//  Evently
//
//  Created by Hanan on 19/11/2024.
//

import Combine

final class EventPublisher<T> {
    private let subject = PassthroughSubject<T, Never>()
    
    var publisher: AnyPublisher<T, Never> {
        subject.eraseToAnyPublisher()
    }
    
    func send(_ event: T) {
        subject.send(event)
    }
}
