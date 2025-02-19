//
//  CreateEventRequest.swift
//  Evently
//
//  Created by Hanan on 17/11/2024.
//

import Foundation

struct CreateEventRequest: Codable {
    let name: String
    let description: String
    let location: String
    let startAtUtc: String
    let endAtUtc: String
}
