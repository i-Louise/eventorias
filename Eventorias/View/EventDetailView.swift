//
//  EventDetailView.swift
//  Eventorias
//
//  Created by Louise Ta on 20/11/2024.
//

import SwiftUI
//import GoogleMaps

struct EventDetailView: View {
    @ObservedObject var viewModel: EventDetailViewModel
    var event: EventResponseModel
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: event.picture)) { phase in
                    switch phase {
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .cornerRadius(10)
                    default:
                        ProgressView()
                    }
                }

                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "calendar")
                            Text(formattedDate(from: event.dateTime))
                        }
                        .foregroundStyle(.white)
                        Spacer()
                        HStack {
                            Image(systemName: "clock")
                            Text(formattedTime(from: event.dateTime))
                        }
                        .foregroundStyle(.white)
                    }
                    Spacer()
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                }
                .padding(.bottom, 10)
                .padding(.top, 10)
                Text(event.description)
                    .foregroundStyle(.white)
                HStack {
                    Text(event.address)
                        .foregroundStyle(.white)
                    GoogleMapView(markerLocation: $viewModel.markerCoordinate, address: event.address)
                        .frame(height: 100)
                        .cornerRadius(10)
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

//#Preview {
//    EventDetailView(
//        viewModel: EventDetailViewModel(),
//        event: Event(
//            title: "Art Exhibition",
//            description: "Join us for an exclusive Art Exhibition showcasing the works of the talented artist Emily Johnson. This exhibition will feature a captivating collection of her contemporary and classical pieces, offering a unique insight into her creative journey. Whether you're an art enthusiast or a casual visitor, you'll have the chance to explore a diverse range of artworks.",
//            dateTime: Date.now,
//            address: "123 Rue de l'Art, Quartier des Galeries, Paris, 75003, France",
//            picture: "https://firebasestorage.googleapis.com/v0/b/eventorias-2ad80.firebasestorage.app/o/tokyo-japan-september-20-2018-600nw-1483381934.webp?alt=media&token=7e5be224-5208-4f65-9b81-6edc7cd78939",
//            category: Event.Category.Art
//        )
//    )
//}
