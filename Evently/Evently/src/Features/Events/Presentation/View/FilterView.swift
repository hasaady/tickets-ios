//
//  FilterView.swift
//  Evently
//
//  Created by Hanan on 02/11/2024.
//
 
import SwiftUI

struct FilterView: View {
    @Binding var filterText: String
    var applyFilter: () -> Void

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Filter by title", text: $filterText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .navigationTitle("Filter Events")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        applyFilter()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
