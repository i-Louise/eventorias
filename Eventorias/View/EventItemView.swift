//
//  EventItemView.swift
//  Eventorias
//
//  Created by Louise Ta on 02/12/2024.
//

import SwiftUI

struct EventItemView: View {
    let event: EventModel
    
    var body: some View {
        HStack {
            profileImage
            eventDetails
            Spacer()
            eventThumbnail
        }
    }
    
    private var profileImage: some View {
        AsyncImage(url: URL(string: event.profilePictureUrl)) { phase in
            switch phase {
            case .failure:
                Image(systemName: "person.fill")
                    .padding()
                    .overlay(
                        Circle()
                            .stroke(Color.primary, lineWidth: 1)
                    )
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            default:
                ProgressView()
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(.gray))
            }
        }
    }
    
    private var eventDetails: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.subheadline)
            Text(formattedDate(from: event.dateTime))
                .font(.caption)
        }
    }
    
    private var eventThumbnail: some View {
        AsyncImage(url: URL(string: event.imageUrl)) { phase in
            switch phase {
            case .failure:
                Image(systemName: "photo")
                    .font(.largeTitle)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 70)
                    .cornerRadius(8)
            default:
                ProgressView()
                    .frame(width: 140, height: 70)
                    .cornerRadius(8)
                    .background(RoundedRectangle(cornerRadius: 16).fill(.gray))
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing, -40)
        .padding(.vertical, -10)
    }
    
    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: date)
    }
}
