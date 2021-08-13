//
//  ApiCalls.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/12/21.
//

import Alamofire
import CoreLocation

class ApiClient {
    static let shared = ApiClient()
    typealias routesCallBack = (Result<[Route], Error>) -> Void

    func requestPlaces(locations: [CLLocationCoordinate2D], completion: @escaping routesCallBack) {
        guard let url = buildUrl(locations: locations) else {
            print("Something wrong happened")
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
                completion(.failure(error))
            }
        }
    }

    private func buildUrl(locations: [CLLocationCoordinate2D]) -> URL? {
        let source = "\(locations[0].latitude),\(locations[0].longitude)"
        let destination = "\(locations[1].latitude),\(locations[1].longitude)"
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(destination)&mode=walking&key=AIzaSyAFCmJTHfdwUprZHZ7pB48Lj6HlYJwKTXw"
        if let url = URL(string: urlString) {
            return url
        } else {
            return nil
        }
    }
}
