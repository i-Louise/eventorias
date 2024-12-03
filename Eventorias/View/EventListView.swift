//
//  EventListView.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore

@MainActor
struct EventListView: View {
    @ObservedObject var viewModel: EventListViewModel
    @State private var searchText = ""
    @State private var isShowingCreateView = false
    @State private var userSearch = ""
    @State private var selectedFilterOption: FilterOption = .newestDate
    @State private var selectedCategory: EventCategory = .all
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                eventsList
                    .toolbar {
                        ToolbarItem(placement: .automatic) {
                            filterMenu
                        }
                        ToolbarItem(placement: .automatic) {
                            categoryMenu
                        }
                    }
                    .onAppear {
                        viewModel.onActionFetchingEvents(sortedByDate: true)
                    }
                createEventButton
            }
            .searchable(text: $userSearch)
        }
    }
    
    private var eventsList: some View {
        List {
            ForEach(searchedResults) { event in
                NavigationLink {
                    EventDetailView(viewModel: EventDetailViewModel(), event: event)
                } label: {
                    EventItemView(event: event)
                }
            }
            .listRowBackground(Color.customGrey)
        }
        .listRowSpacing(8.0)
        .background(Color.background)
        .scrollContentBackground(.hidden)
    }
    
    private var filterMenu: some View {
        Menu("Sort by: \(selectedFilterOption.rawValue)") {
            Button("Oldest") {
                selectedFilterOption = .olderDate
                viewModel.onActionFetchingEvents(sortedByDate: false, category: selectedCategory.rawValue)
            }
            Button("Newest") {
                selectedFilterOption = .newestDate
                viewModel.onActionFetchingEvents(sortedByDate: true, category: selectedCategory.rawValue)
            }
        }
    }
    
    private var categoryMenu: some View {
        Menu("Category \(selectedCategory.rawValue)") {
            ForEach(EventCategory.allCases, id: \.self) { category in
                Button("\(category.rawValue)") {
                    selectedCategory = category
                    viewModel.onActionFetchingEvents(category: category == .all ? nil : category.rawValue)
                }
            }
        }
    }
    
    private var createEventButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination:
                                CreateEventView(
                                    viewModel: CreateEventViewModel(
                                        addService: AddEventService(),
                                        onCreationSucceed: {
                                            print("fetch events done")
                                        }
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
    
    var searchedResults: [EventModel] {
        
        if userSearch.isEmpty {
            print("Searched results: \(viewModel.events.map { $0.dateTime })")
            return viewModel.events
        } else {
            return viewModel.events.filter { event in
                event.title.localizedCaseInsensitiveContains(userSearch)
            }
        }
    }
}
