//
//  EventListViewModel.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

import Foundation
import RealmSwift
import SwiftIContainer
import Combine
 
class EventListViewModel: ObservableObject {
    @Injected var eventPublisher: EventPublisher<ServicesEvent>
    
    @Published var events: [EventEntity] = []
    @Published var isShowingFilter = false
    @Published var filterText = ""
    @Published var isLoading = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadEvents()
        subscriptions()
    }
    
    private func subscriptions() {
        eventPublisher.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                self?.handleEvent(event)
            }
            .store(in: &cancellables)
    }
    
    private func handleEvent(_ event: ServicesEvent) {
        switch event {
        case .didClearData:
            events.removeAll()
            getEvents()
        }
    }

    func loadEvents() {
        Task {
            do {
                let result = try await GetCacheEventsUseCase().execute()
                await MainActor.run {
                    self.events = result
                }
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
                let result = try await FetchEventsUseCase().execute()
//
//                DispatchQueue.main.async {
//                    self.events = result
//                }

            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
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
