//
//  PostListViewModel.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 14/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import Foundation
import UIKit

protocol PostListViewModelDelegate: class {
    func didSelectPost(_ post: Post)
    func traitCollectionDidChangeToCompact()
    func traitCollectionDidChangeToRegular()
}

class PostListViewModel {
    weak var delegate: PostListViewModelDelegate?
    
    // MARK: - Constants
    let networkManager: NetworkManager
    let dataManager: DataManager
    
    // MARK: - Variables
    lazy var topPostChildren = [TopPostChildren]()
    lazy var topPost = [Post]()
    var viewController: PostListViewController?
    
    init(networkManager: NetworkManager, dataManager: DataManager) {
        self.networkManager = networkManager
        self.dataManager = dataManager
    }
    
    func refreshList() {
        viewController?.tableView.reloadData()
    }
    
    func setPostAsRead(_ postId: String) {
        let selectedPost = topPost.filter {$0.id == postId }.first
        selectedPost?.setRead()
        refreshList()
    }
}

extension PostListViewModel: PostListViewControllerDelegate {
    func getPostThumbnailImage(from url: URL, completion:  @escaping (UIImage?, Error?) -> ()) {
        networkManager.downloadImage(from: url) { (image, error) in
            completion(image, error)
        }
    }
    
    func loadTopPost(completion: @escaping () -> ()) {
        if let topPostChildren = dataManager.getTopPost() {
            self.topPostChildren = topPostChildren
           populateTopPosts()
        }
        completion()
    }
    
    func getNumberOfRows() -> Int {
        return topPost.count
    }
    
    func getPost(at indexPath: IndexPath) -> Post? {
        return topPost[indexPath.row]
    }
    
    func getPostPosition(for post: Post) -> Int? {
        for (index, savedPost) in topPost.enumerated() {
            if savedPost.id == post.id {
                return index
            }
        }
        
        return nil
    }
    
    func removePosts(_ posts: [Post]) {
        let filteredPost = topPost.filter {!posts.contains($0)}
        topPost = filteredPost
    }
    
    func didSelectPost(at index: Int) {
        delegate?.didSelectPost(topPost[index])
    }
    
    func traitCollectionDidChangeToCompact() {
        delegate?.traitCollectionDidChangeToCompact()
    }
    
    func traitCollectionDidChangeToRegular() {
        delegate?.traitCollectionDidChangeToRegular()
    }
}

// MARK: - Private Methods
extension PostListViewModel {
    private func populateTopPosts() {
        for children in topPostChildren {
            if let data = children.data {
                topPost.append(data)
            }
        }
    }
    
    private func populateTopPost(with post: Post?) {
        if let data = post {
            topPost.append(data)
        }
    }
}
