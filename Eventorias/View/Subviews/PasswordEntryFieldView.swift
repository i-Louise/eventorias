//
//  PasswordEntryFieldView.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import SwiftUI

struct PasswordEntryFieldView: View {
    @Binding var password: String
    @State private var hidePassword = true
    var placeHolder: String
    var errorMessage: String? = nil
    
    var body: some View {
        HStack {
            Image(systemName: "lock.fill")
            if hidePassword {
                SecureField(placeHolder, text: $password)
                    .accessibilityIdentifier("passwordSecuredTextField")
            } else {
                TextField(placeHolder, text: $password)
                    .accessibilityIdentifier("passwordTextField")
            }
            Button(action: {
                self.hidePassword.toggle()
            }, label: {
                Image(systemName: hidePassword ? "eye.fill" : "eye.slash.fill")
                    .foregroundStyle(.gray)
            })
            .accessibilityIdentifier("passwordVisibilityButton")

        }
        .padding()
        .background(.customGrey)
        .cornerRadius(8)
        .disableAutocorrection(true)
        
        if let errorMessage = errorMessage {
            Text(errorMessage)
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
                .foregroundColor(.red)
        }
    }
}

