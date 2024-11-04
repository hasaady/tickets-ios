//
//  EventEntity.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

import Foundation
import RealmSwift

class EventEntity: Object, Identifiable {
    @Persisted(primaryKey: true) var id: UUID = UUID()
    @Persisted var name: String = ""
    @Persisted var location: String = ""
    @Persisted var desc: String = ""
    @Persisted var startAtUtc: String = ""
    @Persisted var endAtUtc: String = ""
    @Persisted var statusRawValue: Int = 0
    
    var status: EventStatus? {
        EventStatus(rawValue: statusRawValue)
    }

}
