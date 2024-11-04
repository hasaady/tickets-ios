//
//  GetEventResposnse.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

import Foundation

struct GetEventResposnse: Codable {
    let events: [EventDto]?
}

struct EventDto: Codable {
    let id: UUID?
    let name: String?
    let location: String?
    let description: String?
    let startAtUtc: String?
    let endAtUtc: String?
    let status: EventStatus?
}

enum EventStatus: Int, Codable  {
    case draft = 0
    case published = 1
    case completed = 2
    case cancelled = 3
}
