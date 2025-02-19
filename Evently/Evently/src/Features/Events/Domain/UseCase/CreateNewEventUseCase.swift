//
//  CreateNewEventUseCase.swift
//  Evently
//
//  Created by Hanan on 17/11/2024.
//

import Foundation
import SwiftIContainer

struct CreateNewEventUseCase : UseCaseProtocol {
    @Injected var repo: EventRepositoryProtocol

    typealias Reqest = (name: String, description: String, location: String, startAtUtc: Date, endAtUtc: Date)
    
    let request: Reqest
    
    init(name: String, description: String, location: String, startAtUtc: Date, endAtUtc: Date) {
        self.request = (name, description, location, startAtUtc, endAtUtc)
    }
    
    func execute() async throws {
        try await repo.createEvent(
            name: request.name,
            description: request.description,
            location: request.location,
            startAtUtc: request.startAtUtc,
            endAtUtc: request.endAtUtc
        )
    }
}
