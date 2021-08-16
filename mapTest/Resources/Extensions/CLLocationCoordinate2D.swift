//
//  CLLocationCoordinate2D.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/15/21.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable, Codable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        if lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude {
            return true
        } else {
            return false
        }
    }
    
    public func encode(to encoder: Encoder) throws {
         var container = encoder.unkeyedContainer()
         try container.encode(longitude)
         try container.encode(latitude)
     }
      
     public init(from decoder: Decoder) throws {
         var container = try decoder.unkeyedContainer()
         let longitude = try container.decode(CLLocationDegrees.self)
         let latitude = try container.decode(CLLocationDegrees.self)
         self.init(latitude: latitude, longitude: longitude)
     }
}
