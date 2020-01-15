//
//  PostDetailViewController.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 15/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import UIKit

protocol PostDetailViewControllerDelegate: class {
    func getUserName() -> String?
    func getPostImage() -> UIImage
    func getPostDescription() -> String?
    func setPostAsRead()
    func didBack()
}

class PostDetailViewController: UIViewController {
    weak var delegate: PostDetailViewControllerDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var userNameUILabel: UILabel!
    @IBOutlet weak var postImageUIImageView: UIImageView!
    @IBOutlet weak var postDescriptionUILabel: UILabel!
    
    // MARK: - Constants
    private struct Constants {
        static let backButtonTitle = "Back"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        delegate?.setPostAsRead()
    }
    
    @objc private func didBack() {
        delegate?.didBack()
    }
}

// MARK: - UI Configuration
extension PostDetailViewController {
    private func setupUI() {
        
        if !(traitCollection.horizontalSizeClass == .compact || traitCollection.verticalSizeClass == .compact) && UIDevice.current.userInterfaceIdiom != .pad {
            setupNavigationBar()
        }
        configureUserNameLabel()
        configurePostImageView()
        configurePostDescriptionLabel()
    }
    
    private func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: Constants.backButtonTitle, style: .plain, target: self, action: #selector(didBack))
        navigationItem.leftBarButtonItem = newBackButton
    }
    
    private func configureUserNameLabel() {
        userNameUILabel.textAlignment = .left
        userNameUILabel.font = UIFont.boldSystemFont(ofSize: 14)
        if let userName = delegate?.getUserName() {
            userNameUILabel.text = userName
        }
    }
    
    private func configurePostImageView() {
        postImageUIImageView.image = delegate?.getPostImage()
        postImageUIImageView.contentMode = .scaleAspectFit
    }
    
    private func configurePostDescriptionLabel() {
        postDescriptionUILabel.textAlignment = .natural
        postDescriptionUILabel.font = UIFont.boldSystemFont(ofSize: 14)
        postDescriptionUILabel.numberOfLines = 0
        if let postDescription = delegate?.getPostDescription() {
            postDescriptionUILabel.text = postDescription
        }
    }
}
