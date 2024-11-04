//
//  EventMapper.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

extension EventEntity {
    
    convenience init?(response: EventDto) {
        guard let id = response.id else { return nil }
        self.init()
        self.id = id
        self.name = response.name ?? ""
        self.location = response.location ?? ""
        self.desc = response.description ?? ""
        self.startAtUtc = response.startAtUtc ?? ""
        self.endAtUtc = response.endAtUtc ?? ""
        self.statusRawValue = response.status?.rawValue ?? 0
    }
}
