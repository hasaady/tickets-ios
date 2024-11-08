//
//  EventDetailsView.swift
//  Evently
//
//  Created by Hanan on 02/11/2024.
//

import SwiftUI
import RealmSwift

struct EventDetailsView: View {
    @ObservedRealmObject var event: EventEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(event.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Date: \(event.startAtUtc)")
                .font(.headline)

            Text(event.description)
                .font(.body)

            Spacer()
        }
        .padding()
        .navigationTitle("Event Details")
    }
}
