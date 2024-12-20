//
//  EventDetailView.swift
//  Eventorias
//
//  Created by Louise Ta on 20/11/2024.
//

import SwiftUI
import GoogleMaps

struct EventDetailView: View {
    var event: EventModel
    @State private var markerCoordinate = CLLocationCoordinate2D(latitude: 41.693333, longitude: 44.801667)
    
    var body: some View {
        ScrollView {
            VStack {
                Text(event.title)
                    .font(.title)
                    .accessibilityIdentifier("eventTitle")
                AsyncImage(url: URL(string: event.imageUrl)) { phase in
                    switch phase {
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 350)
                            .clipped()
                            .cornerRadius(10)
                    default:
                        ZStack {
                            ProgressView()
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray)
                                .frame(width: 350, height: 350)
                        }
                    }
                }.accessibilityIdentifier("eventImage")


                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "calendar")
                            Text(formattedDate(from: event.dateTime))
                                .accessibilityIdentifier("eventDate")
                        }
                        .foregroundStyle(.white)
                        Spacer()
                        HStack {
                            Image(systemName: "clock")
                            Text(formattedTime(from: event.dateTime))
                                .accessibilityIdentifier("eventTime")
                        }
                        .foregroundStyle(.white)
                    }
                    Spacer()
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
                    }.accessibilityIdentifier("profilePicture")
                }
                .padding(.bottom, 10)
                .padding(.top, 10)
                Text(event.description)
                    .foregroundStyle(.white)
                    .accessibilityIdentifier("eventDescription")
                HStack {
                    Text(event.address)
                        .foregroundStyle(.white)
                        .accessibilityIdentifier("eventAddress")
                    GoogleMapView(markerLocation: $markerCoordinate, address: event.address)
                        .frame(height: 100)
                        .cornerRadius(10)
                        .accessibilityIdentifier("googleMapView")
                }
                .padding(.bottom, 10)
                .padding(.top, 10)
            }
            .padding()
        }
        .background(Color.background)
    }
    
    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: date)
    }
    
    private func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        return formatter.string(from: date)
    }
}
