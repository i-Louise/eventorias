//
//  EventListView.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import SwiftUI

struct EventListView: View {
    @ObservedObject var viewModel: EventListViewModel
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List(viewModel.filteredEvents) { event in
                NavigationLink(destination: EventDetailView(viewModel: EventDetailViewModel(), event: event)) {
                    HStack {
                        Image(systemName: "person.fill")
                            .padding()
                            .overlay(
                                Circle()
                                    .stroke(Color.primary,
                                            lineWidth:1))
                        VStack(alignment: .leading) {
                            Text(event.title)
                                .font(.headline)
                            Text(formattedDate(from: event.dateTime))
                                .font(.subheadline)
                        }
                        Spacer()
                        AsyncImage(url: URL(string: event.picture)) { phase in
                            switch phase {
                            case .failure:
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width / 3, height: 50)
                                    .edgesIgnoringSafeArea(.all)
                                
                            default:
                                ProgressView()
                            }
                        }
                        .clipShape(.rect(cornerRadius: 16))
                        
                    }
                    .foregroundStyle(Color.white)
                }
                .listRowBackground(Color.customGrey)
            }
            .listStyle(.insetGrouped)
            .onAppear {
                viewModel.fetchEvents()
            }
            .background(Color.background)
            .scrollContentBackground(.hidden)
        }.searchable(text: $viewModel.searchText)

    }
    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    EventListView(viewModel: EventListViewModel())
}
