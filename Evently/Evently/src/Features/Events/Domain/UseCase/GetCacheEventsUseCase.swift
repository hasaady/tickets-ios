//
//  GetCacheEventsUseCase.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

import SwiftIContainer

struct GetCacheEventsUseCase {
    @Injected var context: DbContext

    func execute() async throws -> [EventEntity] {
        let result = try await context.fetchAll(EventEntity.self)
        return Array(result)
    }
}
