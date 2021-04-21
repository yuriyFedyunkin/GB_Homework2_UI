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
    private let gradient = GradientView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        refreshNews()
        
        
//        newsfeedNetworkReqeust()
        
        //Градиенти для tableView
        gradient.setupGeneralGradientView(for: self.tableView)
    }
    
    // Newsfeed network request
//    private func newsfeedNetworkReqeust() {
//        parser.parseNews { [weak self] posts in
//            self?.postFeedList = posts
//            self?.tableView.reloadData()
//        }
//    }
    
    fileprivate func setupRefreshControl() {
        // Инициализируем и присваиваем сущность UIRefreshControl
        refreshControl = UIRefreshControl()
        // Настраиваем свойства контрола, как, например,
        // отображаемый им текст
        refreshControl?.attributedTitle = NSAttributedString(string: "Updating...")
        // Цвет спиннера
        refreshControl?.tintColor = .purple
        // И прикрепляем функцию, которая будет вызываться контролом
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func refreshNews() {
        // Начинаем обновление новостей
        self.refreshControl?.beginRefreshing()
        // Определяем время самой свежей новости
        // или берем текущее время
        let mostFreshNewsDate = self.postFeedList.first?.date ?? Date.timeIntervalSinceReferenceDate
        
        parser.parseNews(startTime: mostFreshNewsDate + 1) { [weak self] (news, nextFrom) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.refreshControl?.endRefreshing()
                
                guard news.count > 0 else { return }
                
                self.postFeedList = news + self.postFeedList
                self.tableView.reloadData()
                
            }
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
       return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

}
