//
//  GetRemoteEventsUseCase.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

import SwiftIContainer
import SwiftUI

protocol UseCaseProtocol {
    associatedtype T
    var repo: T { get }
}

struct FetchEventsUseCase : UseCaseProtocol {
    @Injected var repo: EventRepositoryProtocol

    func execute() async throws /*-> [EventEntity]*/ {
        let result = try await repo.getEvents()
        //try await SaveEventsUseCase(entities: result).execute()
        //return result
    }
}
