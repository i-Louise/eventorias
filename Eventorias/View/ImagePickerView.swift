//
//  ImagePickerView.swift
//  Eventorias
//
//  Created by Louise Ta on 28/11/2024.
//

import SwiftUI

struct ImagePickerView: View {
    @Binding var showSheet: Bool
    @Binding var image: UIImage?
    
    var body: some View {
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
                ImagePicker(sourceType: .camera, selectedImage: self.$image)
            }
        }
    }
}
//
//#Preview {
//    ImagePickerView(showSheet: $showSheet, image: $image)
//}
