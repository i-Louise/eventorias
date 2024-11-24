//
//  CreateEventView.swift
//  Eventorias
//
//  Created by Louise Ta on 22/11/2024.
//

import SwiftUI

struct CreateEventView: View {
    @State var title: String = ""
    @State var description: String = ""
    @State var dateTime = Date()
    @State var address: String = ""
    @State var showSheet = false
    @State var image: UIImage?
    @State var category: EventCategory = .other
    @ObservedObject var viewModel: CreateEventViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Field(fieldName: "Title", placeHolder: "Write the title of your event", userInput: $title)
                    VStack {
                        Text("Category")
                        Picker("Category", selection: $category) {
                            ForEach(EventCategory.allCases, id: \.self) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 15)
                    .background(.customGrey, in: RoundedRectangle(cornerRadius: 10))
                    
                    Field(fieldName: "Description", placeHolder: "Tell more about your event", userInput: $description)
                    DatePicker("Date and Time", selection: $dateTime)
                        .tint(.customRed)
                        .padding()
                        .background(.customGrey, in: RoundedRectangle(cornerRadius: 10))
                    Field(fieldName: "Address", placeHolder: "Enter the full address", userInput: $address)
                    
                }
                HStack(spacing: 20) {
                    Button {
                        showSheet = true
                    } label: {
                        Image(systemName: "camera")
                    }
                    .padding()
                    .frame(width: 50, height: 50)
                    .background(Color.white)
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .sheet(isPresented: $showSheet) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                    }
                    Button {
                        showSheet = true
                    } label: {
                        Image(systemName: "paperclip")
                    }
                    .padding()
                    .frame(width: 50, height: 50)
                    .background(Color.customRed)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    .sheet(isPresented: $showSheet) {
                        ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                    }
                }
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
                    viewModel.onCreationAction(address: address, category: category, date: dateTime, description: description, picture: imageData, title: title)
                } label: {
                    Text("Validate")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.customRed)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
            .background(Color.background)
        }
        .navigationTitle("Creation of an event")
    }
    
    private func mapUiImageToData(image: UIImage) -> Data? {
        return image.jpegData(compressionQuality: 0.75)
    }
}

struct Field: View {
    var fieldName: String
    var placeHolder: String
    @Binding var userInput: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(fieldName)
            ZStack(alignment: .leading) {
                if userInput.isEmpty {
                    Text(placeHolder)
                        .font(.subheadline)
                }
                TextField("", text: $userInput)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .background(.customGrey, in: RoundedRectangle(cornerRadius: 10))
    }
}
