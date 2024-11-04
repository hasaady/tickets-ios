//
//  GetRemoteEventsUseCase.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

struct GetRemoteEventsUseCase {
    @Injected var repo: EventRepositoryProtocol
 
    func execute() async throws -> [EventEntity] {
        try await repo.getEvents()
    }
}
