//
//  RegistrationView.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import SwiftUI
import PhotosUI

struct RegistrationView: View {
    @Binding var showPopover: Bool
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var image: UIImage?
    @State private var showCameraSheet = false
    @State private var showGallerySheet = false
    @ObservedObject var viewModel: RegistrationViewModel
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    Text("Register")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.customRed)
                        .accessibilityIdentifier("registrationTitle")
                    Text("Create a new account")
                        .font(.headline)
                        .foregroundColor(.white)
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .cornerRadius(50)
                            .padding(.all, 4)
                            .frame(width: 100, height: 100)
                            .background(Color.white)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .padding(8)
                            .accessibilityIdentifier("profilePicture")
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .cornerRadius(50)
                            .padding(.all, 4)
                            .frame(width: 100, height: 100)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .padding(8)
                            .accessibilityIdentifier("placeHolderProfilePicture")
                    }
                    ImagePickerView(showCameraSheet: $showCameraSheet, showGallerySheet: $showGallerySheet, image: $image)
                        .accessibilityIdentifier("imagePickerView")
                }
                
                EntryFieldView(placeHolder: "First Name", field: $firstName, errorMessage: viewModel.firstNameErrorMessage, imageName: "person.fill")
                    .accessibilityIdentifier("firstNameTextField")
                EntryFieldView(placeHolder: "Last Name", field: $lastName, errorMessage: viewModel.lastNameErrorMessage, imageName: "person.fill")
                    .accessibilityIdentifier("lastNameTextField")
                EntryFieldView(placeHolder: "Mail address", field: $email, errorMessage: viewModel.emailErrorMessage, imageName: "mail.fill")
                    .accessibilityIdentifier("mailAddressTextField")
                PasswordEntryFieldView(password: $password, placeHolder: "Password", errorMessage: viewModel.passwordErrorMessage)
                    .accessibilityIdentifier("passwordSecuredField")
                PasswordEntryFieldView(password: $confirmPassword, placeHolder: "Confirm password", errorMessage: viewModel.confirmPasswordErrorMessage)
                    .accessibilityIdentifier("passwordConfirmSecuredField")
                Button {
                    guard let image else {
                        // TODO: tell the user image cannot be empty
                        return
                    }
                    let imageData = mapUiImageToData(image: image)
                    guard let imageData else {
                        // TODO: image could not be compressed, show a generic error to the user (?)
                        // So a new event cannot be created in this case!
                        return
                    }
                    viewModel.onSignUpAction(
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: password,
                        confirmPassword: confirmPassword,
                        image: imageData,
                        onSuccess: {
                            dismiss()
                        },
                        onFailure: { alertMessage in
                            self.viewModel.alertMessage = alertMessage
                        }
                    )
                } label: {
                    Text("Create")
                        .frame(maxWidth: .infinity)
                }
                .fontWeight(.bold)
                .padding()
                .background(Color(.customRed))
                .cornerRadius(5)
                .accessibilityIdentifier("createButton")
            }
            .padding(.horizontal, 40)
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(
                title: Text("An Error occured"),
                message: Text(viewModel.alertMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }.overlay(
            ProgressViewCustom(isLoading: viewModel.isLoading)
        )
    }
    
    private func mapUiImageToData(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.75)
    }
}
