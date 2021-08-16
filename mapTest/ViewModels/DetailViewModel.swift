//
//  DetailViewModel.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/15/21.
//

import Foundation

protocol DetailViewModelType: class {
    func deleteRoute()
}

class DetailViewModel: DetailViewModelType {
    private var viewController: DetailViewController!
    var detailedRoute: UserRoute?
    
    init(viewController: DetailViewController) {
        self.viewController = viewController
    }
    
    private func removeSafely(route: UserRoute?) {
        guard let data = UserDefaults.standard.data(forKey: "userRoutes"),
              var routes = try? JSONDecoder().decode([UserRoute].self, from: data)
        else { return }
        for (index, route) in routes.enumerated() {
            if route == self.detailedRoute {
                routes.remove(at: index)
            }
        }
        saveSafely(routes: routes)
    }
    
    private func saveSafely(routes: [UserRoute]?) {
        guard let newData = try? JSONEncoder().encode(routes) else { return }
        UserDefaults.standard.set(newData, forKey: "userRoutes")
    }
    
    func deleteRoute() {
        self.removeSafely(route: self.detailedRoute)
    }
}
