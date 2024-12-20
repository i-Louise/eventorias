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
            if let _ = viewModel.errorMessage {
                ErrorView(viewModel: viewModel)
            } else {
                ZStack {
                    VStack(spacing: 10) {
                        HStack {
                            filterMenu
                            categoryMenu
                        }
                        eventsList
                    }
                    .onAppear {
                        viewModel.onActionFetchingEvents(sortedByDate: true, category: selectedCategory.rawValue)
                    }
                    createEventButton
                    if viewModel.isLoading && viewModel.events.isEmpty {
                        ProgressView()
                            .frame(width: 500, height: 500)
                    }
                }
                .searchable(text: $userSearch)
            }
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
        .scrollContentBackground(.hidden)
    }
    
    private var filterMenu: some View {
        Menu {
            Button("Oldest") {
                selectedFilterOption = .olderDate
                viewModel.onActionFetchingEvents(sortedByDate: false, category: selectedCategory.rawValue)
            }
            Button("Newest") {
                selectedFilterOption = .newestDate
                viewModel.onActionFetchingEvents(sortedByDate: true, category: selectedCategory.rawValue)
            }
        } label: {
            Label("Sorting", systemImage: "arrow.up.arrow.down")
        }
        .accessibilityIdentifier("filterMenu")
        .font(.subheadline)
        .padding(8)
        .background(Color.customGrey)
        .foregroundStyle(.white)
        .clipShape(Capsule())
    }
    
    private var categoryMenu: some View {
        Menu {
            ForEach(EventCategory.allCases, id: \.self) { category in
                Button("\(category.rawValue)") {
                    selectedCategory = category
                    viewModel.onActionFetchingEvents(category: category == .all ? nil : category.rawValue)
                }
            }
        } label: {
            Label("Category: \(selectedCategory.rawValue)", systemImage: "line.3.horizontal.decrease.circle.fill")
        }
        .accessibilityIdentifier("categoryButton")
        .font(.subheadline)
        .padding(8)
        .background(Color.customGrey)
        .foregroundStyle(.white)
        .clipShape(Capsule())
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
    
    struct ErrorView: View {
        var viewModel: EventListViewModel
        
        var body: some View {
            VStack(alignment: .center) {
                Text("!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(width: 60, height: 60)
                    .background(.gray)
                    .clipShape(Circle())
                    .padding()
                Text("Error")
                    .font(.title2)
                Text("An error has occured, \n please try again later")
                .padding(2)
                Button {
                    viewModel.onActionFetchingEvents()
                } label: {
                    Text("Try again")
                }
                .frame(width: 150)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .padding()
                .background(Color.customRed)
                .cornerRadius(5)
            }
        }
    }
}
