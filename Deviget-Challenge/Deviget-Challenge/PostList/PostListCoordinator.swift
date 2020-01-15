//
//  PostListCoordinator.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 14/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import UIKit

class PostListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Constants
    private struct Constants {
        static let postListStoryboardName = "PostListViewController"
        static let postListViewControllerName = "PostListViewController"
    }
    
    // MARK: - Variables
    var rootViewController: UINavigationController {
        return navigationController
    }
    
    private var navigationController: UINavigationController = {
      let navigationController = UINavigationController()
      return navigationController
    }()
    var viewModel: PostListViewModel?
    
    func start() {
        let storyboard = UIStoryboard(name: Constants.postListStoryboardName, bundle: nil)
        guard let postListViewController = storyboard.instantiateViewController(withIdentifier: Constants.postListViewControllerName) as? PostListViewController else { return }
        
        let viewModel = PostListViewModel(networkManager: NetworkManager(), dataManager: DataManager())
        postListViewController.delegate = viewModel
        viewModel.viewController = postListViewController
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        
        rootViewController.viewControllers = [postListViewController]
    }
}

// MARK: - PostListViewModelDelegate
extension PostListCoordinator: PostListViewModelDelegate {
    func didSelectPost(_ post: Post) {
        let postDetailViewCoordinator = PostDetailCoordinator()
        postDetailViewCoordinator.delegate = self
        postDetailViewCoordinator.start(with: post)
        add(childCoordinator: postDetailViewCoordinator)
        if let postDetailViewController = postDetailViewCoordinator.rootViewController {
            rootViewController.pushViewController(postDetailViewController, animated: true)
        }
    }
}

// MARK: - PostDetailViewModelDelegate
extension PostListCoordinator: PostDetailCoordinatorDelegate {
    func didBack() {
        viewModel?.refreshList()
    }
    
    func setPostAsRead(_ postId: String) {
        viewModel?.setPostAsRead(postId)
    }
}
