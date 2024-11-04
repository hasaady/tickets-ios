//
//  EventListView.swift
//  Evently
//
//  Created by Hanan on 27/10/2024.
//

import SwiftUI

struct EventListView: View {
    @StateObject var viewModel = EventListViewModel()
    
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
                    Button(action: { viewModel.isShowingFilter.toggle() }) {
                        Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowingFilter) {
                FilterView(filterText: $viewModel.filterText, applyFilter: viewModel.filterEvents)
            }
            .alert(isPresented: $viewModel.showError, content: {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            })
            //.onAppear(perform: viewModel.getRemoteEvents)
        }
    }
}

#Preview {
    EventListView()
}
