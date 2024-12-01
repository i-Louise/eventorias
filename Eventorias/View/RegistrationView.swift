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
    @State private var isLoading: Bool = false
    @State private var image: UIImage?
    @State private var showCameraSheet = false
    @State private var showGallerySheet = false
    @ObservedObject var viewModel: RegistrationViewModel
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
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
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .cornerRadius(50)
                            .padding(.all, 4)
                            .frame(width: 100, height: 100)
                            .background(Color.white)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .padding(8)
                    }
                    ImagePickerView(showCameraSheet: $showCameraSheet, showGallerySheet: $showGallerySheet, image: $image)
                }
                EntryFieldView(placeHolder: "First Name", field: $firstName, imageName: "person.fill")
                EntryFieldView(placeHolder: "Last Name", field: $lastName, imageName: "person.fill")
                EntryFieldView(placeHolder: "Mail address", field: $email, imageName: "mail.fill")
                PasswordEntryFieldView(password: $password, placeHolder: "Password")
                PasswordEntryFieldView(password: $confirmPassword, placeHolder: "Confirm password")
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
                        onLoading: { isLoading in
                            self.isLoading = isLoading
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
            }
            .padding(.horizontal, 40)
        }
    }
    
    private func mapUiImageToData(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.75)
    }
}

#Preview {
    @Previewable @State var showPopover = true
    RegistrationView(showPopover: $showPopover, viewModel: RegistrationViewModel())
}
