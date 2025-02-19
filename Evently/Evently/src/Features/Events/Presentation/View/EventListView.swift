//
//  EventListView.swift
//  Evently
//
//  Created by Hanan on 27/10/2024.
//

import SwiftUI

struct EventListView: View {
    @StateObject var viewModel = EventListViewModel()
    @State private var isShowingCreateEventView = false // State to control modal presentation

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading events...")
                        .padding()
                } else {
                    List(viewModel.events) { event in
                        NavigationLink(destination: EventDetailsView(event: event)) {
                            VStack(alignment: .leading) {
                                Text(event.name)
                                    .font(.headline)
                                Text(event.startAtUtc)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: viewModel.deleteEvents) {
                        Label("Delete All", systemImage: "trash")
                    }
                    .disabled(viewModel.events.isEmpty)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: viewModel.getEvents) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
                ToolbarItem(placement: .bottomBar) { // Add to bottom bar if preferred
                    Button(action: { isShowingCreateEventView = true }) {
                        Label("Create New Event", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingCreateEventView) {
                CreateEventView() // Present a view for creating new events
            }
            .alert(isPresented: $viewModel.showError, content: {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            })
        }
    }
}

#Preview {
    EventListView()
}
