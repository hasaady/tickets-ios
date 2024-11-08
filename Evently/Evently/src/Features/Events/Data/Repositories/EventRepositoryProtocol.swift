//
//  EventRepositoryProtocol.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

import SwiftIContainer
import SwiftNetwork

protocol EventRepositoryProtocol {
    func getEvents() async throws -> [EventEntity]
}

class EventRepository: EventRepositoryProtocol {
    @Injected var provider : NetworkProvider
    
    func getEvents() async throws -> [EventEntity] {
        do {
            let response: GetEventResposnse = try await provider.get(path: "/events")
            let result = response.events?.compactMap {EventEntity(response: $0) } ?? []
            return result
        } catch {
            throw error
        }
    }
}
