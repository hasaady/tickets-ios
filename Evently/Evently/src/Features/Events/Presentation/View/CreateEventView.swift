//
//  CreateEventView.swift
//  Evently
//
//  Created by Hanan on 17/11/2024.
//

import SwiftUI

struct CreateEventView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = CreateEventViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Details")) {
                    TextField("Event Name", text: $viewModel.eventName)
                        .autocapitalization(.words)
                    TextField("Description", text: $viewModel.description)
                        .autocapitalization(.sentences)
                    TextField("Location", text: $viewModel.location)
                        .autocapitalization(.words)
                }
                
                Section(header: Text("Event Timing")) {
                    DatePicker("Start Date & Time", selection: $viewModel.startAtUtc, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End Date & Time", selection: $viewModel.endAtUtc, displayedComponents: [.date, .hourAndMinute])
                }
                
                if viewModel.isLoading {
                    ProgressView("Creating event...")
                        .padding()
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .navigationTitle("Create Event")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.createEvent()
                    }
                    .disabled(viewModel.eventName.isEmpty || viewModel.description.isEmpty || viewModel.location.isEmpty || viewModel.isLoading)
                }
            }
            .onChange(of: viewModel.isEventCreated) { isCreated in
                if isCreated {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    CreateEventView()
}
