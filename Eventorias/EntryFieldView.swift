//
//  EntryFieldView.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import SwiftUI

struct EntryFieldView: View {
    var placeHolder: String
    @Binding var field: String
    var isSecure: Bool = false
    var errorMessage: String? = nil
    var imageName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: imageName)
                    .frame(maxWidth: 15)
                if isSecure {
                    SecureField(placeHolder, text: $field)
                } else {
                    TextField(placeHolder, text: $field)
                }
            }
            .padding()
            .textInputAutocapitalization(.never)
            .background(Color(UIColor.secondarySystemBackground))
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
}

#Preview {
    @Previewable @State var email: String = ""
    @Previewable @State var imageName: String = ""

    EntryFieldView(placeHolder: "Email adress", field: $email, imageName: imageName)
}
