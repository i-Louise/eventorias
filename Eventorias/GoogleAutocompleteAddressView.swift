//
//  GoogleAutocompleteAddressView.swift
//  Eventorias
//
//  Created by Louise Ta on 01/12/2024.
//

import Foundation
import UIKit
import GooglePlaces
import SwiftUI

struct GoogleAutocompleteAddressView: UIViewControllerRepresentable {
    @Binding var address: String
    @Binding var coordinate: CLLocationCoordinate2D?
    
    func makeUIViewController(context: Context) -> GMSAutocompleteViewController {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = context.coordinator
        return autocompleteController
    }

    func updateUIViewController(_ uiViewController: GMSAutocompleteViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedAddress: $address, coordinate: $coordinate)
    }

    class Coordinator: NSObject, GMSAutocompleteViewControllerDelegate {
        @Binding var selectedAddress: String
        @Binding var coordinate: CLLocationCoordinate2D?

        init(selectedAddress: Binding<String>, coordinate: Binding<CLLocationCoordinate2D?>) {
            _selectedAddress = selectedAddress
            _coordinate = coordinate
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            selectedAddress = place.formattedAddress ?? ""
            coordinate = place.coordinate
            viewController.dismiss(animated: true, completion: nil)
        }

        func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("Error: \(error.localizedDescription)")
            viewController.dismiss(animated: true, completion: nil)
        }

        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}
