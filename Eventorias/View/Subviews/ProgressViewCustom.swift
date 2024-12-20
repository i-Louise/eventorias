//
//  ProgressViewCustom.swift
//  Eventorias
//
//  Created by Louise Ta on 19/12/2024.
//

import SwiftUI

struct ProgressViewCustom: View {
    var isLoading: Bool
    
    var body: some View {
        Group {
            if isLoading {
                Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                ProgressView()
                    .padding()
                    .background(Color.customRed)
                    .tint(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
        }
    }
}
