//
//  NewsFeedController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 21.03.2021.
//  Copyright © 2021 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class NewsFeedController: UITableViewController {

    private var postFeedList = [NewsfeedPost]()
    private let parser = NewsParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsfeedNetworkReqeust()
        
        //Градиенти для tableView
        let gradient = GradientView()
        gradient.setupGradient(startColor: .blue, endColor: .systemGray, startLocation: 0, endLocation: 1, startPoint: .zero, endPoint: CGPoint(x:0, y: 1))
        gradient.alpha = 0.6
        tableView.backgroundView = gradient
    }
    
    // Newsfeed network request
    private func newsfeedNetworkReqeust() {
        parser.parseNews { [weak self] posts in
            self?.postFeedList = posts
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postFeedList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostFeedCell")
                for post in postFeedList {
                    if post.type == "post" {
                        let postCell = tableView.dequeueReusableCell(withIdentifier: "PostFeedCell", for: indexPath) as! PostFeedCell
                        postCell.configure(postFeedList[indexPath.row])
                        postCell.selectionStyle = .none
                        return postCell
                    } else if post.type == "photo" {
                        let photoCell = tableView.dequeueReusableCell(withIdentifier: "PhotoFeedCell", for: indexPath) as! PhotoFeedCell
                        photoCell.configure(postFeedList[indexPath.row])
                        photoCell.selectionStyle = .none
                        return photoCell
                    }
                }
       return cell!
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

}