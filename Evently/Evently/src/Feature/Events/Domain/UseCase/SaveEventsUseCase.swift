//
//  SaveContnetUseCase.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

struct SaveEventsUseCase {
    @Injected var context: DbContext

    let entities: [EventEntity]
    
    func execute() async throws {
        try await context.replace(entities)
    }
}

struct AddEventsUseCase {
    @Injected var context: DbContext

    let entities: [EventEntity]
    
    func execute() async throws {
        try await context.add(entities)
    }
}
