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
    func getPostImage(completion:  @escaping (UIImage?, Error?) -> ())
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
        static let photoPlaceholderImageName = "photoPlaceholder"
        static let imageSaveNoErrorTitle = "Saved!"
        static let imageSaveNoErrorMessage = "Your image has been saved to your photos."
        static let imageSaveErrorTitle = "Save error"
        static let imageSaveErrorMessage = "An error occured during image save"
        static let okActionButtonTitle = "OK"
    }
    private let photoPlacelholderImage = UIImage(named: Constants.photoPlaceholderImageName)
    enum ImageSaveResult {
        case success
        case fail
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

// MARK: - Private Methods
extension PostDetailViewController {
    private func setImageToImageView(with activityIndicator: UIActivityIndicatorView) {
        activityIndicator.startAnimating()
        delegate?.getPostImage(completion: {[weak self] (image, error) in
            DispatchQueue.main.async {
                if let _ = error {
                    activityIndicator.stopAnimating()
                } else {
                    if let image = image {
                        self?.postImageUIImageView.image = image
                    }
                }
                
                activityIndicator.removeFromSuperview()
            }
        })
    }
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if let tappedImage = tapGestureRecognizer.view as? UIImageView,
            let image = tappedImage.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            present(getAlertForImageSave(.fail, additionalData: ["Error": error]), animated: true)
        } else {
            present(getAlertForImageSave(.success), animated: true)
        }
    }
    
    private func getAlertForImageSave(_ result: ImageSaveResult, additionalData: [String: Error?]? = nil) -> UIAlertController {
        switch result {
        case .success:
            return createSuccessAlertForImagaSaved()
        case .fail:
            return createFailAlertForImagaSaved(with: additionalData?["Error"] ?? nil)
        }
    }
    
    private func createSuccessAlertForImagaSaved() -> UIAlertController {
        let alertController = UIAlertController(title: Constants.imageSaveNoErrorTitle, message: Constants.imageSaveNoErrorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.okActionButtonTitle, style: .default))
        return alertController
    }
    
    private func createFailAlertForImagaSaved(with error: Error?) -> UIAlertController {
        var errorMesssage: String = Constants.imageSaveErrorMessage
        if let localizedErrorMesssage = error?.localizedDescription {
            errorMesssage = localizedErrorMesssage
        }
        let alertController = UIAlertController(title: Constants.imageSaveErrorTitle, message: errorMesssage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constants.okActionButtonTitle, style: .default))
        return alertController
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
        postImageUIImageView.contentMode = .scaleAspectFit
        postImageUIImageView.image = photoPlacelholderImage
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        postImageUIImageView.isUserInteractionEnabled = true
        postImageUIImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = postImageUIImageView.center
        postImageUIImageView.addSubview(activityIndicator)
        
        setImageToImageView(with: activityIndicator)
        
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
