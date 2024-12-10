//
//  EventListView.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import SwiftUI

@MainActor
struct EventListView: View {
    @ObservedObject private var viewModel: EventListViewModel
    @State private var searchText = ""
    @State private var isShowingCreateView = false
    @State private var userSearch = ""
    @State private var selectedFilterOption: FilterOption = .newestDate
    @State private var selectedCategory: EventCategory = .all
    
    init(viewModel: EventListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                eventsList
                    .accessibilityIdentifier("eventList")
                    .toolbar {
                        ToolbarItem(placement: .automatic) {
                            filterMenu
                        }
                        ToolbarItem(placement: .automatic) {
                            categoryMenu
                        }
                    }
                    .onAppear {
                        viewModel.onActionFetchingEvents(sortedByDate: true, category: selectedCategory.rawValue)
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
                    EventDetailView(event: event)
                        .accessibilityIdentifier("eventDetailView")
                } label: {
                    EventItemView(event: event)
                        .accessibilityIdentifier("eventItemView")
                }
            }
            .listRowBackground(Color.customGrey)
        }
        .accessibilityIdentifier("eventList")
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
            .accessibilityIdentifier("oldestFilterButton")
            Button("Newest") {
                selectedFilterOption = .newestDate
                viewModel.onActionFetchingEvents(sortedByDate: true, category: selectedCategory.rawValue)
            }
            .accessibilityIdentifier("newestFilterButton")
        }
        .accessibilityIdentifier("filterMenu")
    }
    
    private var categoryMenu: some View {
        Menu("Category \(selectedCategory.rawValue)") {
            ForEach(EventCategory.allCases, id: \.self) { category in
                Button("\(category.rawValue)") {
                    selectedCategory = category
                    viewModel.onActionFetchingEvents(category: category == .all ? nil : category.rawValue)
                }
                .accessibilityIdentifier("\(category.rawValue)")
            }
        }
        .accessibilityIdentifier("categoryButton")
    }
    
    private var createEventButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: CreateEventView(viewModel: viewModel.createEventViewModel)
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
                .accessibilityIdentifier("createEventButton")
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
