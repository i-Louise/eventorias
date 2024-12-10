//
//  UserProfileView.swift
//  Eventorias
//
//  Created by Louise Ta on 19/11/2024.
//

import SwiftUI

struct UserProfileView: View {
    @State var notification = false
    @ObservedObject var viewModel: UserProfileViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("User profile")
                        Spacer()
                        AsyncImage(url: URL(string: viewModel.user?.profilePicture ?? "")) { phase in
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
                        }.accessibilityIdentifier("userProfileImage")
                    }
                    VStack {
                        Text("Name")
                        Text(viewModel.user?.firstName ?? "")
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(.customGrey, in: RoundedRectangle(cornerRadius: 10))
                    .accessibilityIdentifier("username")
                    
                    VStack {
                        Text("E-mail")
                        Text(viewModel.user?.email ?? "")
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(.customGrey, in: RoundedRectangle(cornerRadius: 10))
                    .accessibilityIdentifier("userEmail")
                    
                    Toggle("Notifications", isOn: $notification)
                        .toggleStyle(SwitchToggleStyle(tint: .customRed))
                        .accessibilityIdentifier("notificationToggle")
                }
            }
            .padding()
            .background(Color.background)
            .onAppear() {
                viewModel.onActionFetchingUserProfile()
            }
        }
    }
}
