//
//  UserProfileView.swift
//  Eventorias
//
//  Created by Louise Ta on 19/11/2024.
//

import SwiftUI

struct UserProfileView: View {
    @State var notification = false
    
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
                        Text("John Doe")
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(.customGrey, in: RoundedRectangle(cornerRadius: 10))
                    
                    VStack {
                        Text("E-mail")
                        Text("John Doe")
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
        }
    }
}

#Preview {
    UserProfileView()
}
