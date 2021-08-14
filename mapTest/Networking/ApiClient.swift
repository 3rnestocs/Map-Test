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
             catch {
                completion(.failure(.badJSON))
            }
        }
    }

    private func buildUrl(locations: [CLLocationCoordinate2D]) -> URL? {
        var finalUrl: URL?
        if !locations.isEmpty {
            let source = "\(locations[0].latitude),\(locations[0].longitude)"
            let destination = "\(locations[1].latitude),\(locations[1].longitude)"
            let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(destination)&mode=walking&key=AIzaSyAFCmJTHfdwUprZHZ7pB48Lj6HlYJwKTXw"
            if let url = URL(string: urlString) {
                finalUrl = url
            } else {
                finalUrl = nil
            }
        }
        return finalUrl
    }
}
