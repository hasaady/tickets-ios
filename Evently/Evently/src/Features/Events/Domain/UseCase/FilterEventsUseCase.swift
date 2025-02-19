//
//  FilterEventsUseCase.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

import Foundation
import SwiftIContainer

struct FilterEventsUseCase {
    @Injected var context: DbContext
    let query: String
    
    func execute() throws -> [EventEntity] {
        let predicate = NSPredicate(format: "body CONTAINS[c] %@", query)
        return try context.fetch(with: predicate, EventEntity.self)
    }

}
