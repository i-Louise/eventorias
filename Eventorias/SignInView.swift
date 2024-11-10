//
//  SignInView.swift
//  Eventorias
//
//  Created by Louise Ta on 09/11/2024.
//

import SwiftUI

struct SignInView: View {
    let background = Color(.background)
    @State private var mail: String = ""
    @State private var password: String = ""
    @State private var showPopover = false
    @State private var isLoading: Bool = false
    @ObservedObject var viewModel: SignInViewModel
    
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                VStack {
                    Image("Icon")
                    Image("Logo")
                        .padding()
                }
                EntryFieldView(placeHolder: "Mail adress", field: $mail, imageName: "person.fill")
                    .keyboardType(.emailAddress)
                PasswordEntryFieldView(password: $password, placeHolder: "Password")
                
                RedButton(
                    title: "Sign in with email",
                    action: {
                        viewModel.onLoginAction(mail: mail, password: password, onLoading: { isLoading -> Void in
                            self.isLoading = isLoading
                        })
                    },
                    image: "envelope",
                    isLoading: $isLoading
                )
                
                Button("Don't have an account? Sign up!") {
                    showPopover = true
                }
                .fontWeight(.bold)
                .popover(isPresented: $showPopover) {
                    RegistrationView(showPopover: $showPopover)
                }
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    SignInView(viewModel: SignInViewModel(authenticationService: AuthenticationService()))
}
