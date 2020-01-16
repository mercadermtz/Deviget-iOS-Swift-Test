//
//  PostDetailViewModel.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 15/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import UIKit

protocol PostDetailViewModelDelegate: class {
    func didBack()
    func setPostAsRead(_ postId: String)
}

class PostDetailViewModel {
    weak var delegate: PostDetailViewModelDelegate?
    
    // MARK: - Constants
    let dataManager: DataManager?
    let networkManager: NetworkManager
    
    // MARK: - Variables
    var post: Post?
    
    init(networkManager: NetworkManager, dataManager: DataManager, post: Post?) {
        self.networkManager = networkManager
        self.dataManager = dataManager
        self.post = post
    }
}

extension PostDetailViewModel: PostDetailViewControllerDelegate {
    func getUserName() -> String? {
        guard let author = post?.author else { return nil }
        return author
    }
    
    func getPostImage(completion:  @escaping (UIImage?, Error?) -> ()) {
        guard let imageURL = post?.thumbnail, let url = URL(string: imageURL) else { return }
        networkManager.downloadImage(from: url) { (image, error) in
            completion(image, error)
        }
    }
    
    func getPostDescription() -> String? {
        guard let postTitle = post?.title else { return nil }
        return postTitle
    }
    
    func setPostAsRead() {
        guard let postId = post?.id else { return }
        delegate?.setPostAsRead(postId)
    }
    
    func didBack() {
        delegate?.didBack()
    }
}
