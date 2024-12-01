//
//  ViewController.swift
//  Eventorias
//
//  Created by Louise Ta on 20/11/2024.
//

import SwiftUI
import UIKit
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    @Binding var markerLocation: CLLocationCoordinate2D
    let address: String

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        geocodeAddress(address: address) { coordinate in
            guard let coordinate = coordinate else { return }
            DispatchQueue.main.async {
                markerLocation = coordinate
                let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
                uiView.camera = camera
                context.coordinator.marker.position = coordinate
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        let mapView = GMSMapView()
        let marker = GMSMarker()
        let coordinator = Coordinator(markerLocation: $markerLocation, mapView: mapView, marker: marker)
        return coordinator
    }
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = context.coordinator.mapView
        mapView.delegate = context.coordinator
        
        mapView.isUserInteractionEnabled = false
        mapView.settings.scrollGestures = false
        mapView.settings.zoomGestures = false
        mapView.settings.tiltGestures = false
        mapView.settings.rotateGestures = false
        //Create Camera View (Location Where We Want To Focus Map Camera)
        let camera = GMSCameraPosition.camera(withTarget: markerLocation, zoom: 15)
        mapView.camera = camera
        //Set Coordinator's Marker Position From ViewModel
        context.coordinator.marker.position = markerLocation
        context.coordinator.marker.isDraggable = false
        context.coordinator.marker.map = mapView
        return mapView
    }
    private func geocodeAddress(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("Geocoding failed: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            completion(location.coordinate)
        }
    }
}


class Coordinator: NSObject, GMSMapViewDelegate {
    @Binding var markerLocation: CLLocationCoordinate2D
    var mapView: GMSMapView
    var marker: GMSMarker
    
    init(markerLocation: Binding<CLLocationCoordinate2D>,
         mapView: GMSMapView,
         marker: GMSMarker
    ) {
        self._markerLocation = markerLocation
        self.mapView = mapView
        self.marker = marker
    }
}
