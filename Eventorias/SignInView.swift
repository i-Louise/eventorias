//
//  SignInView.swift
//  Eventorias
//
//  Created by Louise Ta on 09/11/2024.
//

import SwiftUI

struct SignInView: View {
    let background = Color(.darkGray)
    
    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            VStack {
                Text("Test")
            }
        }
    }
}

#Preview {
    SignInView()
}
