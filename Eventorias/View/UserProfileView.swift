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
                        Image(systemName: "person.crop.circle.fill")
                    }
                    VStack {
                        Text("Name")
                        Text(viewModel.user?.firstName ?? "")
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(.customGrey, in: RoundedRectangle(cornerRadius: 10))
                    
                    VStack {
                        Text("E-mail")
                        Text(viewModel.user?.email ?? "")
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(.customGrey, in: RoundedRectangle(cornerRadius: 10))
                    
                    Toggle("Notifications", isOn: $notification)
                        .toggleStyle(SwitchToggleStyle(tint: .customRed))
                }
            }
            .padding()
            .background(Color.background)
            .onAppear() {
                viewModel.fetchUserProfile()
            }
        }
    }
}
//
//#Preview {
//    UserProfileView(viewModel: UserProfileViewModel(), user: <#UserResponseModel#>)
//}
