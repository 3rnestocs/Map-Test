//
//  ApiCalls.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/12/21.
//

import Alamofire
import CoreLocation

enum ErrorCases: Error {
    case buildUrl
    case badJSON
}

class ApiClient {
    static let shared = ApiClient()
    typealias routesCallBack = (Result<[Route], ErrorCases>) -> Void

    func requestPlaces(locations: [CLLocationCoordinate2D], completion: @escaping routesCallBack) {
        guard let url = buildUrl(locations: locations) else {
            completion(.failure(.buildUrl))
            return
        }

        AF.request(url).responseJSON { response in
            guard let data = response.data else {
                return
            }

            do {
                let jsonData = try JSONDecoder().decode(RouteResponse.self, from: data)
                let routes = jsonData.routes
                completion(.success(routes))
            }
             catch let error {
                print("DEBUG", error)
                completion(.failure(.badJSON))
            }
        }
    }

    private func buildUrl(locations: [CLLocationCoordinate2D]) -> URL? {
        guard let coord1 = locations.first,
              let coord2 = locations.last  else {
            return nil
        }
        
        let source = "\(coord1.latitude),\(coord1.longitude)"
        let destination = "\(coord2.latitude),\(coord2.longitude)"
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(destination)&mode=walking&key=AIzaSyAFCmJTHfdwUprZHZ7pB48Lj6HlYJwKTXw"

        if let url = URL(string: urlString) {
            return url
        } else {
            return nil
        }
    }
}
