//
//  CreateEventView.swift
//  Eventorias
//
//  Created by Louise Ta on 22/11/2024.
//

import SwiftUI
import GooglePlaces
import GooglePlacesSwift

struct CreateEventView: View {
    @State var title: String = ""
    @State var description: String = ""
    @State var dateTime = Date()
    @State var address: String = ""
    @State var showGallerySheet = false
    @State var showCameraSheet = false
    @State var image: UIImage?
    @State var category: EventCategory = .other
    @ObservedObject var viewModel: CreateEventViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showAutocomplete = false
    @State private var coordinate: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    titleField
                        .accessibilityIdentifier("titleTextField")
                    CategoryPicker(selectedCategory: $category)
                    descriptionField
                        .accessibilityIdentifier("descriptionTextField")
                    datePicker
                        .accessibilityIdentifier("datePicker")
                    addressField
                        .accessibilityIdentifier("addressTextField")
                    imageUploadSection
                    validateButton
                        .accessibilityIdentifier("validateButton")
                }
                .sheet(isPresented: $showAutocomplete) {
                    GoogleAutocompleteAddressView(address: $address, coordinate: $coordinate)
                        .accessibilityIdentifier("googleAutoComplete")
                }
            }
            .padding()
            .background(Color.background)
            .onAppear {
                viewModel.onCreationSucceed = { dismiss() }
            }
        }
        .navigationTitle("Creation of an event")
    }
}

extension CreateEventView {
    private var titleField: some View {
        Field(fieldName: "Title", placeHolder: "Write the title of your event", userInput: $title)
    }
    
    struct CategoryPicker: View {
        @Binding var selectedCategory: EventCategory
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Category")
                Picker("Category", selection: $selectedCategory) {
                    ForEach(EventCategory.allCasesForPicker, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .accentColor(.white)
            }
            .accessibilityIdentifier("categoryPicker")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background(Color.customGrey, in: RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var descriptionField: some View {
        Field(fieldName: "Description", placeHolder: "Tell more about your event", userInput: $description)
    }
    
    private var datePicker: some View {
        DatePicker("Date and Time", selection: $dateTime)
            .tint(.customRed)
            .padding()
            .background(.customGrey, in: RoundedRectangle(cornerRadius: 10))
    }
    
    private var addressField: some View {
        Field(fieldName: "Address", placeHolder: "Enter the full address", userInput: $address)
            .disabled(true)
            .onTapGesture {
                showAutocomplete = true
            }
    }
    
    private var imageUploadSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Upload a picture")
                .padding()
            ImagePickerView(showCameraSheet: $showCameraSheet, showGallerySheet: $showGallerySheet, image: $image)
                .accessibilityIdentifier("imagePickerView")
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 350, height: 350)
                    .clipped()
                    .cornerRadius(10)
                    .padding(.vertical, 15)
            }
        }
    }
    
    private var validateButton: some View {
        Button {
            guard let image else {
                // TODO: tell the user image cannot be empty
                return
            }
            guard let imageData = mapUiImageToData(image: image) else {
                // TODO: image could not be compressed, show a generic error to the user
                return
            }
            viewModel.onCreationAction(address: address, category: category, date: dateTime, description: description, image: imageData, title: title)
        } label: {
            Text("Validate")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.customRed)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
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
