//
//  PostDetailCoordinator.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 15/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import UIKit

protocol PostDetailCoordinatorDelegate: class {
    func didBack()
    func setPostAsRead(_ postId: String)
}

class PostDetailCoordinator: Coordinator {
    weak var delegate: PostDetailCoordinatorDelegate?
    
    // MARK: - Constants
    private struct Constants {
        static let postDetailStoryboardName = "PostDetailViewController"
        static let postDetailViewControllerName = "PostDetailViewController"
    }
    
    // MARK: - Variables
    var rootViewController: UIViewController?
    var childCoordinators: [Coordinator] = []
    
    var viewModel: PostDetailViewModel?
    
    func start(with post: Post?) {
        let storyboard = UIStoryboard(name: Constants.postDetailStoryboardName, bundle: nil)
        guard let postDetailViewController = storyboard.instantiateViewController(withIdentifier: Constants.postDetailViewControllerName) as? PostDetailViewController else { return }
        
        let viewModel = PostDetailViewModel(networkManager: NetworkManager(), dataManager: DataManager(), post: post)
        viewModel.delegate = self
        self.viewModel = viewModel
        postDetailViewController.delegate = viewModel
        
        rootViewController = postDetailViewController
    }
}

extension PostDetailCoordinator: PostDetailViewModelDelegate {
    func didBack() {
        delegate?.didBack()
    }
    
    func setPostAsRead(_ postId: String) {
        delegate?.setPostAsRead(postId)
    }
}

