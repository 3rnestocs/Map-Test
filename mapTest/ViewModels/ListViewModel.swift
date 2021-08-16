//
//  ListViewModel.swift
//  mapTest
//
//  Created by Ernesto Jose Contreras Lopez on 8/15/21.
//

import Foundation

protocol ListViewModelType: class {
    func getRoutes() -> [UserRoute]
}

class ListViewModel {
    private var viewController: ListViewController!
    var routesSaved: [UserRoute]?
    
    init(viewController: ListViewController) {
        self.viewController = viewController
    }
    
    func saveRoutes(route: UserRoute) {
        if self.getRoutes().isEmpty {
            self.saveSafely(routes: [route])
        } else {
            self.updateSafely(newRoute: route)
        }
    }
    
    private func saveSafely(routes: [UserRoute]?) {
        guard let newData = try? JSONEncoder().encode(routes) else { return }
        UserDefaults.standard.set(newData, forKey: "userRoutes")
    }
    
    private func updateSafely(newRoute: UserRoute) {
        guard let data = UserDefaults.standard.data(forKey: "userRoutes"),
              var routes = try? JSONDecoder().decode([UserRoute].self, from: data)
        else { return }
        routes.append(newRoute)
        saveSafely(routes: routes)
    }
    
    private func getSafely() -> [UserRoute]? {
        guard let data = UserDefaults.standard.data(forKey: "userRoutes"),
              let routes = try? JSONDecoder().decode([UserRoute].self, from: data)
        else { return nil }
        return routes
    }
    
    func getRoutes() -> [UserRoute] {
        guard let routes = self.getSafely() else { return [UserRoute]() }
        return routes
    }
}
