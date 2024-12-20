//
//  SignInView.swift
//  Eventorias
//
//  Created by Louise Ta on 09/11/2024.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = "test@gmail.com"
    @State private var password: String = "test123"
    @State private var showPopover = false
    @State private var isLoading: Bool = false
    @State private var showAlert = false
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
                EntryFieldView(placeHolder: "Email address", field: $email, imageName: "person.fill")
                    .keyboardType(.emailAddress)
                    .accessibilityIdentifier("emailTextField")
                PasswordEntryFieldView(password: $password, placeHolder: "Password")
                
                RedButton(
                    title: "Sign in with email",
                    action: {
                        viewModel.onLoginAction(
                            email: email,
                            password: password
                        )
                    },
                    image: "envelope",
                    isLoading: $isLoading
                )
                .accessibilityIdentifier("signInButton")
                
                Button("Don't have an account? Sign up!") {
                    showPopover = true
                }
                .fontWeight(.bold)
                .popover(isPresented: $showPopover) {
                    RegistrationView(showPopover: $showPopover, viewModel: viewModel.registrationViewModel)
                }
                .accessibilityIdentifier("signUpButton")
            }
            .padding(.horizontal, 40)
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(
                title: Text("An Error occured"),
                message: Text(viewModel.alertMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
        .overlay(
            ProgressViewCustom(isLoading: viewModel.isLoading)
        )
    }
}
