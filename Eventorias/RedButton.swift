//
//  redButton.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import SwiftUI

struct RedButton: View {
    let title: String
    var action: () -> Void
    var image: String
    @Binding var isLoading: Bool
    
    var body: some View {
        Button(action: action, label: {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity)
            } else {
                Image(systemName: image)
                Text(title)
            }
        })
        .frame(maxWidth: .infinity)
        .fontWeight(.bold)
        .padding()
        .background(Color(.customRed))
        .cornerRadius(5)
        
    }
}

#Preview {
    RedButton(title: "Click here", action: {} , image: "heart.fill", isLoading: .constant(false))
}
