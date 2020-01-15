//
//  Coordinator.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 14/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
    func add(childCoordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === childCoordinator }) else {
          return
        }
        
        childCoordinators.append(childCoordinator)
    }
    func remove(childCoordinator: Coordinator) {
        childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}

