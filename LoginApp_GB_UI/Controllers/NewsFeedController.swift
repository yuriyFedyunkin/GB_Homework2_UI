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
    var nextFrom: String?
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
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
                
                if self.nextFrom == nil,
                   let nextFrom = nextFrom {
                    self.nextFrom = nextFrom
                }

                // формируем IndexSet свежедобавленных секций и обновляем таблицу
                let indexSet = IndexSet(integersIn: 0..<news.count)
                self.tableView.insertSections(indexSet, with: .automatic)
                
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return postFeedList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                for post in postFeedList {
                    if post.type == "post" {
                        let postCell = tableView.dequeueReusableCell(withIdentifier: "PostFeedCell", for: indexPath) as! PostFeedCell
                        postCell.configure(postFeedList[indexPath.section])
                        postCell.selectionStyle = .none
                        return postCell
                    } else if post.type == "photo" {
                        let photoCell = tableView.dequeueReusableCell(withIdentifier: "PhotoFeedCell", for: indexPath) as! PhotoFeedCell
                        photoCell.configure(postFeedList[indexPath.section])
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

extension NewsFeedController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // Выбираем максимальный номер секции, которую нужно будет отобразить в ближайшее время
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        // Проверяем,является ли эта секция одной из трех ближайших к концу
        if maxSection > postFeedList.count - 3,
           // Убеждаемся, что мы уже не в процессе загрузки данных
           !isLoading {
            // Начинаем загрузку данных и меняем флаг isLoading
            isLoading = true
            // Обратите внимание, что сетевой сервис должен уметь обрабатывать входящий параметр nextFrom
            parser.parseNews(startFrom: nextFrom ?? "") { [weak self] (news, nextFrom) in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    let indexSet = IndexSet(integersIn: self.postFeedList.count ..< self.postFeedList.count + news.count)
                    self.postFeedList.append(contentsOf: news)
                    // Обновляем таблицу
                    self.tableView.insertSections(indexSet, with: .automatic)
                    // Выключаем статус isLoading
                    self.isLoading = false
                    self.nextFrom = nextFrom
                    
                }
            }
        }
    }
}
