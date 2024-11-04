//
//  EventListViewModel.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

import Foundation
import RealmSwift

class EventListViewModel: ObservableObject {
    @ObservedResults(EventEntity.self) var events
    
    @Published var filteredEvents: [EventEntity] = []
    
    @Published var isShowingFilter = false
    @Published var filterText = ""
    @Published var isLoading = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    func getCacheEvents() {

        Task {
            do {
                debugPrint("fetching cached events")
                _ = try await GetCacheEventsUseCase().execute()
            } catch {
                debugPrint(error)
            }
        }
    }
    
    func getEvents() {
        isLoading = true
        showError = false

        Task {
            do {
                debugPrint("requesting remote events")
                let events = try await GetRemoteEventsUseCase().execute()
                try await SaveEventsUseCase(entities: events).execute()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            
            isLoading = false
        }
    }
    
    func deleteEvents() {
        showError = false

        Task {
            do {
                debugPrint("deleting cache events")
                try await DeleteConentUseCase().execute()
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
    
    func filterEvents() {
        Task {
            do {
                debugPrint("filtering cache events")
                _ = try await FilterEventsUseCase(query: filterText).execute()
            } catch {
                debugPrint(error)
            }
        }
    }
}
