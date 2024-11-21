//
//  EventDetailViewModel.swift
//  Eventorias
//
//  Created by Louise Ta on 20/11/2024.
//

import Foundation
import CoreLocation

class EventDetailViewModel: ObservableObject {
    @Published var markerCoordinate = CLLocationCoordinate2D(latitude: 41.693333, longitude: 44.801667)
    
}

