//
//  DeleteConentUseCase.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

struct DeleteConentUseCase {
    @Injected var context: DbContext
 
    func execute() async throws {
        try await context.deleteAll(EventEntity.self)
    }
}
