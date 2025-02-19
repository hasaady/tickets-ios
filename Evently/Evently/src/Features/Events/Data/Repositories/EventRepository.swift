//
//  EventRepositoryProtocol.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

import SwiftIContainer
import SwiftNetwork
import Foundation

protocol RepositoryProtocol {}

protocol EventRepositoryProtocol: RepositoryProtocol {
    func getEvents() async throws -> [EventEntity]
    func createEvent(name: String, description: String, location: String, startAtUtc: Date, endAtUtc: Date) async throws
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
    
    func createEvent(name: String, description: String, location: String, startAtUtc: Date, endAtUtc: Date) async throws {
        do {
            let formatter = ISO8601DateFormatter()
            
            let request = CreateEventRequest(
                name: name,
                description: description,
                location: location,
                startAtUtc: formatter.string(from: startAtUtc),
                endAtUtc: formatter.string(from: endAtUtc)
            )
            
            let response: CreateEventResponse = try await provider.post(path: "/events", body: request)

        } catch {
            throw error
        }
    }
}
