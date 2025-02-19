//
//  CreateNewEventViewModel.swift
//  Evently
//
//  Created by Hanan on 17/11/2024.
//

import Foundation
import Combine

class CreateEventViewModel: ObservableObject {
    @Published var eventName: String = ""
    @Published var description: String = ""
    @Published var location: String = ""
    @Published var startAtUtc: Date = Date()
    @Published var endAtUtc: Date = Date()
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var isEventCreated: Bool = false

    private var cancellables = Set<AnyCancellable>()

    func createEvent() {
        guard validateInputs() else { return }

        isLoading = true
        errorMessage = ""
        
        Task {
            do {
                try await CreateNewEventUseCase(
                    name: eventName,
                    description: description,
                    location: location,
                    startAtUtc: startAtUtc,
                    endAtUtc: endAtUtc
                ).execute()
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isEventCreated = true
                }
                
            } catch {
                debugPrint("failed to create event: \(error)")
            }
        }
    }
    
    private func validateInputs() -> Bool {
        if eventName.isEmpty {
            errorMessage = "Event name cannot be empty."
            return false
        }
        if description.isEmpty {
            errorMessage = "Description cannot be empty."
            return false
        }
        if location.isEmpty {
            errorMessage = "Location cannot be empty."
            return false
        }
        if startAtUtc >= endAtUtc {
            errorMessage = "Start time must be before end time."
            return false
        }
        return true
    }
}
