//
//  DeleteConentUseCase.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

import SwiftIContainer

struct DeleteConentUseCase {
    @Injected var context: DbContext
    @Injected var eventPublisher: EventPublisher<ServicesEvent>
 
    func execute() async throws {
        try await context.deleteAll(EventEntity.self)
        eventPublisher.send(.didClearData)
    }
}
