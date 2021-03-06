//
//  PostListViewController.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 14/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import UIKit

import UIKit

protocol PostListViewControllerDelegate: class {
    func loadTopPost(completion: @escaping () -> ())
    func getNumberOfRows() -> Int
    func getPost(at indexPath: IndexPath) -> Post?
    func getPostThumbnailImage(from url: URL, completion:  @escaping (UIImage?, Error?) -> ())
    func getPostPosition(for post: Post) -> Int?
    func removePosts(_ posts: [Post])
    func didSelectPost(at index: Int)
    func traitCollectionDidChangeToCompact()
    func traitCollectionDidChangeToRegular()
}

class PostListViewController: UIViewController {
    
    weak var delegate: PostListViewControllerDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dismissAllPostUIButton: UIButton!
    
    // MARK: - Constants
    private struct Constants {
        static let viewTitle = "Reddit Posts"
        static let tableViewCellIdentifier = "postListTableViewCell"
        static let nibCellName = "PostListTableViewCell"
        static let refreshControlTitle = "Pull to refresh"
        static let dismissAllTitle = "Dismiss All"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        loadData {
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                self.configureView()
            }
        }
    }
    
    @objc func refresh(sender: AnyObject) {
        loadData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc func deleteAllCurrentPost() {
        var indexPathArray = [IndexPath]()
        var postArray = [Post]()
        for cell in tableView.visibleCells {
            if let cellIndexPath = tableView.indexPath(for: cell) {
                indexPathArray.append(cellIndexPath)
                
                if let safePost = delegate?.getPost(at: cellIndexPath) {
                    postArray.append(safePost)
                }
            }
        }
        delegate?.removePosts(postArray)
        tableView.deleteRows(at: indexPathArray, with: .automatic)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.verticalSizeClass == .compact {
            delegate?.traitCollectionDidChangeToCompact()
        } else {
            delegate?.traitCollectionDidChangeToRegular()
        }
        
    }
}

// MARK: - Private Methods
extension PostListViewController {
    private func configureView() {
        view.backgroundColor = .black
        title = Constants.viewTitle
        configureTableView()
        configureDismissAllPostButton()
    }
    
    private func configureTableView() {
        let postListTableViewCell = UINib(nibName: Constants.nibCellName, bundle: nil)
        tableView.register(postListTableViewCell, forCellReuseIdentifier: Constants.tableViewCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        
        let tableViewRefreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tableViewRefreshControl.attributedTitle = NSAttributedString(string: Constants.refreshControlTitle, attributes: attributes)
        tableViewRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableViewRefreshControl.tintColor = .white
        tableView.refreshControl = tableViewRefreshControl
    }
    
    private func configureDismissAllPostButton() {
        dismissAllPostUIButton.setTitle(Constants.dismissAllTitle, for: .normal)
        let buttonTitleColor = UIColor(red: 0.98, green: 0.5, blue: 0.2, alpha: 1.0)
        dismissAllPostUIButton.setTitleColor(buttonTitleColor, for: .normal)
        dismissAllPostUIButton.addTarget(self, action: #selector(deleteAllCurrentPost), for: .touchUpInside)
    }
    
    private func loadData(completion: @escaping () -> ()) {
        delegate?.loadTopPost(completion: { completion() })
    }
}

// MARK: TableView Delege & Data Source
extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.getNumberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellIdentifier) as? PostListTableViewCell else { return UITableViewCell() }
        if let post = delegate?.getPost(at: indexPath) {
            cell.delegate = self
            cell.configure(with: post)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectPost(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: UIScrollViewDelegate
extension PostListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if currentOffset >= maximumOffset{
            loadData { self.tableView.reloadData() }
        }
    }
}

// MARK: PostListTableViewCellProtocol
extension PostListViewController: PostListTableViewCellProtocol {
    func getPostThumbnailImage(from url: URL, completion:  @escaping (UIImage?, Error?) -> ()) {
        delegate?.getPostThumbnailImage(from: url, completion: { (image, error) in
            completion(image, error)
        })
    }
    
    func deletePost(_ post: Post) {
        guard let postPosition = delegate?.getPostPosition(for: post) else { return }
        delegate?.removePosts([post])
        let indexToDelete = IndexPath(row: postPosition, section: 0)
        tableView.deleteRows(at: [indexToDelete], with: .automatic)
        
    }
}

