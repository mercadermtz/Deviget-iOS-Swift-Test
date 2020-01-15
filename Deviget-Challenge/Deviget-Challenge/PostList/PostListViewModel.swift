//
//  PostListViewModel.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 14/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

protocol PostListViewModelDelegate: class {
    //
}

class PostListViewModel {
    weak var delegate: PostListViewModelDelegate?
    
    // MARK: - Constants
    let dataManager: DataManager
    
    // MARK: - Variables
    lazy var topPostChildren = [TopPostChildren]()
    lazy var topPost = [Post]()
    var viewController: PostListViewController?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
}

extension PostListViewModel: PostListViewControllerDelegate {
    func getNumberOfRows() -> Int {
        return topPost.count
    }
    
    func loadTopPost(completion: @escaping () -> ()) {
        if let topPostChildren = dataManager.getTopPost() {
            self.topPostChildren = topPostChildren
        }
        completion()
    }
}
