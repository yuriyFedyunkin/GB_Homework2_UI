//
//  NewsController.swift
//  LoginApp_GB_UI
//
//  Created by Yuriy Fedyunkin on 23.12.2020.
//  Copyright © 2020 Yuriy Fedyunkin. All rights reserved.
//

import UIKit

class NewsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newsTable: UITableView!
    
    let newsTexts = [String](News.news.keys)
    let newsImages = [String](News.news.values)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTable.delegate = self
        newsTable.dataSource = self
        
        newsTable.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")

        let gradient = GradientView()
        gradient.setupGradient(startColor: .blue, endColor: .systemGray, startLocation: 0, endLocation: 1, startPoint: .zero, endPoint: CGPoint(x:0, y: 1))
        gradient.alpha = 0.6
        newsTable.backgroundView = gradient
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTable.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        
        cell.newsTitle.text = newsTexts[indexPath.row]
        cell.newsImage.image = UIImage(named: newsImages[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
}
