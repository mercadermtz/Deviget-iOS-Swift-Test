//
//  PostListTableViewCell.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 15/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import UIKit

protocol PostListTableViewCellProtocol: class {
    func getPostThumbnailImage(from url: URL, completion:  @escaping (UIImage?, Error?) -> ())
    func deletePost(_ post: Post)
}

class PostListTableViewCell: UITableViewCell {
    
    weak var delegate: PostListTableViewCellProtocol?
    
    // MARK: - IB Outlets
    @IBOutlet weak var unreadIndicatorUIImageView: UIImageView!
    @IBOutlet weak var userNameUILabel: UILabel!
    @IBOutlet weak var postCreationTimeUILabel: UILabel!
    @IBOutlet weak var postThumbnailUIImageView: UIImageView!
    @IBOutlet weak var postDescriptionPreviewUILabel: UILabel!
    @IBOutlet weak var dismissPostUIButton: UIButton!
    @IBOutlet weak var commentsQuantityUILabel: UILabel!
    
    // MARK: - Constants
    private struct Constants {
        static let unreadIndicatorImageName = "unreadIndicator"
        static let photoPlaceholderImageName = "photoPlaceholder"
        static let closeIconImageName = "closeIcon"
        static let commentsQuantityColor = UIColor(red: 0.98, green: 0.5, blue: 0.2, alpha: 1.0)
    }
    private let unreadImage = UIImage(named: Constants.unreadIndicatorImageName)
    private let photoPlacelholderImage = UIImage(named: Constants.photoPlaceholderImageName)
    private let closeIconImage = UIImage(named: Constants.closeIconImageName)?.withRenderingMode(.alwaysTemplate)
    
    // MARK: - Variables
    var currentPost: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with post: Post) {
        currentPost = post
        
        if let postId = post.id {
            unreadIndicatorUIImageView.isHidden = UserDefaults.standard.bool(forKey: "\(postId)")
        }
        
        userNameUILabel.text = post.author
        
        postCreationTimeUILabel.text = post.getHoursFromTimeIntervalAsSTring()
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = postThumbnailUIImageView.center
        postThumbnailUIImageView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        if let thumbnailURL = post.thumbnail,
            let url = URL(string: thumbnailURL){
            delegate?.getPostThumbnailImage(from: url, completion: {[weak self] (image, error) in
                 DispatchQueue.main.async {
                    if let _ = error {
                        activityIndicator.stopAnimating()
                    } else {
                        self?.postThumbnailUIImageView.image = image
                    }
                    
                    activityIndicator.removeFromSuperview()
                }
            })
        } else {
            activityIndicator.stopAnimating()
        }
        
        postDescriptionPreviewUILabel.text = post.title
        
        commentsQuantityUILabel.text = "\(post.numComments) comments"
    }
    
    @objc private func dismissPost(sender: UIButton!) {
        guard let post = currentPost else { return }
        delegate?.deletePost(post)
    }
}

// MARK: - UI Configuration
extension PostListTableViewCell {
    func setupUI() {
        configureUnreadIndicator()
        configureUserName()
        configurePhotoThumbnail()
        configurePostTitle()
        configureDismissPostButton()
        configureCommentsQuantity()
    }
    
    private func configureUnreadIndicator() {
        unreadIndicatorUIImageView.image = unreadImage
        unreadIndicatorUIImageView.contentMode = .scaleAspectFit
    }
    
    private func configureUserName() {
        userNameUILabel.textAlignment = .left
        userNameUILabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private func configurePhotoThumbnail() {
        postThumbnailUIImageView.image = photoPlacelholderImage
        postThumbnailUIImageView.contentMode = .scaleAspectFit
    }
    
    private func configurePostTitle() {
        postDescriptionPreviewUILabel.numberOfLines = 0
        postDescriptionPreviewUILabel.textAlignment = .natural
    }
    
    private func configureDismissPostButton() {
        dismissPostUIButton.setTitle("Dismiss", for: .normal)
        dismissPostUIButton.setTitleColor(.white, for: .normal)
        dismissPostUIButton.setImage(closeIconImage, for: .normal)
        dismissPostUIButton.imageView?.contentMode = .scaleAspectFit
        dismissPostUIButton.tintColor = Constants.commentsQuantityColor
        dismissPostUIButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        dismissPostUIButton.addTarget(self, action: #selector(dismissPost), for: .touchUpInside)
    }
    
    private func configureCommentsQuantity() {
        commentsQuantityUILabel.textColor = Constants.commentsQuantityColor
        commentsQuantityUILabel.textAlignment = .left
    }
}
