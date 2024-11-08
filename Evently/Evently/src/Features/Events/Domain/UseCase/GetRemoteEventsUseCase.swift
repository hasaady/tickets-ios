//
//  GetRemoteEventsUseCase.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

import SwiftIContainer

struct GetRemoteEventsUseCase {
    
    @Injected var repo: EventRepositoryProtocol
 
    func execute() async throws -> [EventEntity] {
        try await repo.getEvents()
    }
}
