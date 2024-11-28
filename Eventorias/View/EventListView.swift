//
//  EventListView.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import SwiftUI

@MainActor
struct EventListView: View {
    @ObservedObject var viewModel: EventListViewModel
    @State private var searchText = ""
    @State private var isShowingCreateView = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(viewModel.events) { event in
                        NavigationLink {
                            EventDetailView(viewModel: EventDetailViewModel(), event: event)
                        } label: {
                            EventItemView(event: event)
                        }
                    }
                    .listRowBackground(Color.customGrey)
                }
                .listStyle(.insetGrouped)
                .background(Color.background)
                .scrollContentBackground(.hidden)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination:
                                        CreateEventView(
                                            viewModel: CreateEventViewModel(
                                                addService: AddEventService(),
                                                {}
                                            )
                                        )
                        ) {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 60, height: 60)
                                .background(Color.customRed)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
                
            }
            //.searchable(text: $viewModel.searchText)
        }
        .onAppear {
            viewModel.fetchEvents()
        }
    }
}

struct EventItemView: View {
    let event: EventModel
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: event.profilePictureUrl)) { phase in
                switch phase {
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                default:
                    ProgressView()
                }
            }
//            Image(systemName: "person.fill")
//                .padding()
//                .overlay(
//                    Circle()
//                        .stroke(Color.primary, lineWidth:1)
//                )
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.headline)
                Text(formattedDate(from: event.dateTime))
                    .font(.subheadline)
            }
            Spacer()
            AsyncImage(url: URL(string: event.imageUrl)) { phase in
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
    
    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    EventListView(viewModel: EventListViewModel())
}
