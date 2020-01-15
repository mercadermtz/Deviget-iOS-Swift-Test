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
        static let postListSplitStoryboardName = "PostListSplitViewController"
        static let postListViewControllerName = "PostListViewController"
        static let postListSplitViewController = "PostListSplitViewController"
        static let postListViewControllerTitle = "PostList"
    }
    
    // MARK: - Variables
    var rootViewController: PostListSplitViewController?
    private var viewModel: PostListViewModel?
    
    func start() {
        startSplitViewController()
    }
}

// MARK: - Private methods
extension PostListCoordinator {
    private func startSplitViewController() {
        let storyboard = UIStoryboard(name: Constants.postListSplitStoryboardName, bundle: nil)
        guard let postListSplitViewController = storyboard.instantiateViewController(withIdentifier: Constants.postListSplitViewController) as? PostListSplitViewController else { return }

        var primaryViewController: UINavigationController
        if let postListViewController = setupPostList() {
            primaryViewController = UINavigationController(rootViewController: postListViewController)
            postListSplitViewController.viewControllers = [primaryViewController]
        }

        rootViewController = postListSplitViewController
    }
    
    private func setupPostList() -> PostListViewController? {
        let storyboard = UIStoryboard(name: Constants.postListStoryboardName, bundle: nil)
        guard let postListViewController = storyboard.instantiateViewController(withIdentifier: Constants.postListViewControllerName) as? PostListViewController else { return nil }
        
        let viewModel = PostListViewModel(networkManager: NetworkManager(), dataManager: DataManager())
        postListViewController.delegate = viewModel
        viewModel.viewController = postListViewController
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        return postListViewController
    }
    
    private func setupPostDetail() -> PostDetailViewController? {
        let postDetailCoordinator = PostDetailCoordinator()
        postDetailCoordinator.start(with: nil)
        postDetailCoordinator.delegate = self
        add(childCoordinator: postDetailCoordinator)
        
        if let detailViewController = postDetailCoordinator.rootViewController as? PostDetailViewController {
            return detailViewController
        }
        
        return nil
    }
    
    private func addPostDetailToSplitViewController() {
        var secondaryViewController: UINavigationController
        if let postDetailViewController = setupPostDetail() {
            secondaryViewController = UINavigationController(rootViewController: postDetailViewController)
            
            rootViewController?.viewControllers.append(secondaryViewController)
        }
    }
    
    private func removePostDetail() {
        guard let postDetailCoordinator = childCoordinators.first as? PostDetailCoordinator else { return }
        remove(childCoordinator: postDetailCoordinator)
        if let safeRootViewController = rootViewController,
            safeRootViewController.viewControllers.count > 1 {
            safeRootViewController.viewControllers.removeLast()
        }
    }
    
}

// MARK: - PostListViewModelDelegate
extension PostListCoordinator: PostListViewModelDelegate {
    func didSelectPost(_ post: Post) {
        guard let safeRootViewContoler = rootViewController else { return }
        
        if let postDetailCoordinator = childCoordinators.first as? PostDetailCoordinator {
            postDetailCoordinator.start(with: post)
            
            if safeRootViewContoler.isCollapsed {
                // Push from post list to detail
                if let postListNavigationController = rootViewController?.viewControllers.first as? UINavigationController,
                    let postDetailViewController = postDetailCoordinator.rootViewController as? PostDetailViewController {
                    postListNavigationController.pushViewController(postDetailViewController, animated: true)
                }
            } else {
                // Refresh detail
                if let postDetailNavigationController = rootViewController?.viewControllers.last as? UINavigationController,
                    let postDetailViewController = postDetailCoordinator.rootViewController as? PostDetailViewController {
                    postDetailNavigationController.viewControllers = [postDetailViewController]
                }
            }
        } else {
            addPostDetailToSplitViewController()
            didSelectPost(post)
        }
    }
    
    func traitCollectionDidChangeToCompact() {
        addPostDetailToSplitViewController()
    }
    
    func traitCollectionDidChangeToRegular() {
        removePostDetail()
    }
}

// MARK: - PostDetailViewModelDelegate
extension PostListCoordinator: PostDetailCoordinatorDelegate {
    func didBack() {
        removePostDetail()
        if let postListNavigationController = rootViewController?.viewControllers.first as? UINavigationController {
            postListNavigationController.popViewController(animated: true)
        }
        viewModel?.refreshList()
    }
    
    func setPostAsRead(_ postId: String) {
        viewModel?.setPostAsRead(postId)
    }
}

