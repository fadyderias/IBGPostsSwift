//
//  PostsTableViewController.swift
//  IBGPostsSwift
//
//  Created by Fady on 6/22/18.
//  Copyright © 2018 instabug. All rights reserved.
//

import UIKit

enum State: Int {
    case active
    case inactive
}

let postTableViewCellIdentifier = "PostTableViewCellIdentifier"

class PostsTableViewController: UITableViewController {
    
    var postsArray = [Post]()
    var pageNumber = 1
    var state: State = .active
    var isPullDownToRefreshEnabled = false
    var isRefreshing = false
    var postsCountLabel = UILabel()
    var pageNumberLabel = UILabel()
    
    lazy var spinner : UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView(style: .gray)
        spinner.frame = CGRect(x: 0, y: 0, width: 320, height: 44)
        return spinner
    }()
    
    lazy var ibgRefreshControl : UIRefreshControl = {
        var refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Posts"
        setupTableView()
        setupNavigationBarLabels()
        setupRefreshControl()
        registerTableViewCells()
        loadPosts()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: postTableViewCellIdentifier, for: indexPath) as! PostTableViewCell
        let post = postsArray[indexPath.row]
        cell.titleLabel.text = post.title
        cell.bodyLabel.text = post.body
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == postsArray.count - 1 && state == .active) {
            enableInfiniteScrollUI()
            loadPosts()
        }
    }
    
    //MARK: - Networking

    func loadPosts() {
        IBGNetworkingManager.sharedInstance.getPostsForPage(pageNumber, completion:{ (posts, error) in
            guard let posts = posts, error == nil else {
                if (self.pageNumber > 1) {
                    self.pageNumber -= 1;
                }
                OperationQueue.main.addOperation({
                    self.updateUIForNetworkCallEnd()
                })
                return
            }
            
            if (self.isRefreshing) {
                self.postsArray.removeAll()
                self.isRefreshing = false
            }
            
            self.postsArray = posts
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
                self.updateForNetworkCallEnd()
            })
        })
    }
    
    //MARK: - Refresh control support

    func setupRefreshControl() {
        extendedLayoutIncludesOpaqueBars = true
        ibgRefreshControl.addTarget(self, action:#selector(reloadNewPosts), for: .valueChanged)
        refreshControl = ibgRefreshControl
    }
    
    @objc func reloadNewPosts() {
        if (isPullDownToRefreshEnabled) {
            pageNumber = 1
            isRefreshing = true
            setToActiveState()
            loadPosts()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Table view support
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 100.0
        tableView.estimatedRowHeight = 100.0
    }
    
    func registerTableViewCells() {
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: postTableViewCellIdentifier)
    }
    
    func setupNavigationBarLabels() {
        let postsCountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
        let postsCountBarButtonItem = UIBarButtonItem(customView: postsCountLabel)
        self.postsCountLabel = postsCountLabel
        navigationItem.rightBarButtonItem = postsCountBarButtonItem

        let postsLoadCountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 50))
        let postsLoadCountBarButtonItem = UIBarButtonItem(customView: postsLoadCountLabel)
        self.pageNumberLabel = postsLoadCountLabel
        navigationItem.leftBarButtonItem = postsLoadCountBarButtonItem
    }
    
    // MARK: - Support

    func updateForNetworkCallEnd() {
        if (state == .active) {
            updateLabelsText()
            pageNumber += 1
        }
        
        updateUIForNetworkCallEnd()
    }
    
    func enableInfiniteScrollUI() {
        spinner.startAnimating()
        tableView.tableFooterView = spinner
    }

    func disableInfiniteScrollUI() {
        spinner.stopAnimating()
        tableView.tableFooterView = nil
    }
    
    func updateUIForNetworkCallEnd() {
        self.disableInfiniteScrollUI()
        ibgRefreshControl.endRefreshing()
    }

    func updateLabelsText() {
        pageNumberLabel.text = String(format: "Page %tu", 0)
        postsCountLabel.text = String(format: "%tu Posts", postsArray.count)
    }

    func setToActiveState() {
        state = .active
    }

    func setToInactiveState() {
        state = .inactive
    }

    func presentNetworkFailureAlertController() {
        let networkingErrorAlertController = UIAlertController.alertControllerWithTitle(title: "Internet Connection Error", message: "Would you like to try again?") {
            self.loadPosts()
        }
        
        self.present(networkingErrorAlertController, animated: true, completion: nil)
    }
}
