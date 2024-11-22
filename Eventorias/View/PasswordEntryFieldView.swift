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
    
    var body: some View {
        HStack {
            Image(systemName: "lock.fill")
            if hidePassword {
                SecureField(placeHolder, text: $password)
            } else {
                TextField(placeHolder, text: $password)
            }
            Button(action: {
                self.hidePassword.toggle()
            }, label: {
                Image(systemName: hidePassword ? "eye.fill" : "eye.slash.fill")
                    .foregroundStyle(.gray)
            })
        }
        .padding()
        .background(.customGrey)
        .cornerRadius(8)
        .disableAutocorrection(true)
    }
}

#Preview {
    @Previewable @State var password: String = ""
    PasswordEntryFieldView(password: $password, placeHolder: "")
}
