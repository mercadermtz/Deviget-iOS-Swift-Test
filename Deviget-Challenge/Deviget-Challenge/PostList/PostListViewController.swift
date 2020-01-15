//
//  PostListViewController.swift
//  Deviget-Challenge
//
//  Created by OLX - Gaston D Ippoliti on 14/01/2020.
//  Copyright © 2020 GastonDippoliti. All rights reserved.
//

import UIKit

protocol PostListViewControllerDelegate: class {
    func loadTopPost(completion: @escaping () -> ())
    func getNumberOfRows() -> Int
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.loadTopPost {
            DispatchQueue.main.async {
                self.configureView()
            }
        }
    }
}

// MARK: - Private Methods
extension PostListViewController {
    private func configureView() {
        title = Constants.viewTitle
    }
}

// MARK: TableView Delege & Data Source
extension PostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.getNumberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellIdentifier) else { return UITableViewCell() }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
