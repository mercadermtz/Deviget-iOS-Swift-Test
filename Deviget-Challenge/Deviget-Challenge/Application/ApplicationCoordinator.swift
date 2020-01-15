//
//  ApplicationCoordinator.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 14/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Constants
    private let window: UIWindow
    
    // MARK: - Variables
    private var postListViewCoordinator: PostListCoordinator?
    private var rootViewController: UINavigationController {
        return navigationController
    }
    
    private var navigationController: UINavigationController = {
      let navigationController = UINavigationController()
      return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func start() {
        postListViewCoordinator = PostListCoordinator()
        postListViewCoordinator?.start()
        window.rootViewController = postListViewCoordinator?.rootViewController
    }
}
