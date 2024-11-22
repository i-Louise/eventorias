//
//  RegistrationView.swift
//  Eventorias
//
//  Created by Louise Ta on 10/11/2024.
//

import SwiftUI

struct RegistrationView: View {
    @Binding var showPopover: Bool
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading: Bool = false
    @State private var image: UIImage?
    @State private var showImagePicker = false
    @ObservedObject var viewModel: RegistrationViewModel
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea(.all)
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    VStack {
                        Text("Register")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.customRed)
                        Text("Create a new account")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
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
                    Text("Upload a profile picture")
                        .foregroundColor(.white)
                    Menu {
                        Button("Choose from Library") {
                            sourceType = .photoLibrary
                            showImagePicker = true
                        }
                        Button("Take Photo") {
                            sourceType = .camera
                            showImagePicker = true
                        }
                    } label: {
                        Label("Select Image", systemImage: "photo.on.rectangle.angled")
                            .font(.title2)
                    }
                }
                .padding()
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(sourceType: sourceType, selectedImage: $image)
                }
                EntryFieldView(placeHolder: "First Name", field: $firstName, imageName: "person.fill")
                EntryFieldView(placeHolder: "Last Name", field: $lastName, imageName: "person.fill")
                EntryFieldView(placeHolder: "Mail adress", field: $email, imageName: "mail.fill")
                PasswordEntryFieldView(password: $password, placeHolder: "Password")
                PasswordEntryFieldView(password: $confirmPassword, placeHolder: "Confirm password")
                Button {
                    viewModel.onSignUpAction(firstName: firstName, lastName: lastName, email: email, password: password, confirmPassword: confirmPassword, profileImage: (image ?? UIImage(systemName: "person.fill"))!, onLoading: { isLoading -> Void in
                        self.isLoading = isLoading
                    })
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
}

#Preview {
    @Previewable @State var showPopover = true
    RegistrationView(showPopover: $showPopover, viewModel: RegistrationViewModel())
}
