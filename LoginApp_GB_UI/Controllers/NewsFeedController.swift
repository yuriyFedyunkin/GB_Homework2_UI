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
    var openedPostIds = Set<Int>()
    var nextFrom: String?
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        setupRefreshControl()
        refreshNews()
        
        //Градиенти для tableView
        gradient.setupGeneralGradientView(for: self.tableView)
    }
    
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
        let newsItem = postFeedList[section]
        if newsItem.photoUrl != nil && newsItem.photoUrl != "" {
            return 2
        } else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newsItem = postFeedList[indexPath.section]
        if indexPath.row == 0 {
            let postCell = tableView.dequeueReusableCell(withIdentifier: "PostFeedCell", for: indexPath) as! PostFeedCell
            postCell.delegate = self
            postCell.configure(newsItem, isOpened: openedPostIds.contains(newsItem.postId))
            postCell.selectionStyle = .none
            return postCell
        } else if let urlString = newsItem.photoUrl {
            let postWithPhotoCell = tableView.dequeueReusableCell(withIdentifier: "AttachedPhoto", for: indexPath) as! AttachedPhotoCell
            
            postWithPhotoCell.configure(urlString)
            postWithPhotoCell.selectionStyle = .none
            return postWithPhotoCell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newsItem = self.postFeedList[indexPath.section]
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        } else if let aspectRatio = newsItem.photoAspectRatio {
            // Вычисляем высоту
            let tableWidth = tableView.bounds.width
            let cellHeight = tableWidth * aspectRatio
            return cellHeight
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let newsItem = self.postFeedList[indexPath.section]
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        } else if let aspectRatio = newsItem.photoAspectRatio {
            // Вычисляем высоту
            let tableWidth = tableView.bounds.width
            let cellHeight = tableWidth * aspectRatio
            return cellHeight
        } else {
            return 0
        }
    }

}

extension NewsFeedController: PostFeedCellDelegate {
    func showTextButtonPressed(postId: Int, isOpened: Bool) {
        if isOpened {
            self.openedPostIds.insert(postId)
        } else {
            self.openedPostIds.remove(postId)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
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
