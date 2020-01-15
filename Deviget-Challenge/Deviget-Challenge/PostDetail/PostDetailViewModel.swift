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
    
    // MARK: - Variables
    var post: Post?
    
    init(dataManager: DataManager, post: Post?) {
        self.dataManager = dataManager
        self.post = post
    }
}

extension PostDetailViewModel: PostDetailViewControllerDelegate {
    func getUserName() -> String? {
        guard let author = post?.author else { return nil }
        return author
    }
    
    func getPostImage() -> UIImage {
        return UIImage()
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
