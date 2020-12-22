//
//  NewsTableViewController.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 6/29/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder
import SideMenu
import RealmSwift

class NewsTableViewController: UITableViewController, NewsProviderDelegate, SideBarDelegate, TableCellDelegate, SavedControllerDelegate {

    let realm = try! Realm()
    var articles: [CachedNews]?
    var newsProvider = NewsProvider()
    var sideBarMenu: SideMenuNavigationController?
    var hasAlreadyLaunched: Bool!
    var selectedCategory = "top-headlines?sources=the-next-web"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsProvider.delegate = self
        
        let sideBarController = SideBarController()
        sideBarController.delegate = self
        sideBarMenu = SideMenuNavigationController(rootViewController: sideBarController)
        sideBarMenu?.leftSide = true
        
        SideMenuManager.default.leftMenuNavigationController = sideBarMenu
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.view, forMenu: SideMenuManager.PresentDirection.left)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(self.refreshControl!)
        
        articles = Array(realm.objects(CachedNews.self).filter("categoryName == 'popular'").sorted(byKeyPath: "publishedAt", ascending: false))
        
        tableView.tableFooterView = UIView()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        hasAlreadyLaunched = UserDefaults.standard.bool(forKey: "hasAlreadyLaunched")
        if !hasAlreadyLaunched {
            UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
            newsProvider.fetchArticles()
        }
        navigationController?.navigationBar.barStyle = .black
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification), name: notificationSendArticles, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateUI(with category: String) {
        do {
            let realm = try Realm()
            self.articles = Array(realm.objects(CachedNews.self).filter("categoryName == %@", category).sorted(byKeyPath: "publishedAt", ascending: false))
            self.tableView.reloadData()
        } catch {
            fatalError()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        newsProvider.fetchArticles()
    }
    
    func runSegue(identifier: String) {
        performSegue(withIdentifier: identifier, sender: self)
    }

    func reload(category: String, navigationBarTitle: String) {
        title = navigationBarTitle
        newsProvider.selectedCategory = category
        newsProvider.fetchArticles()
    }
    
    func saveButtonClicked(post: CachedNews) {
        let realm = try! Realm()
        let article = realm.objects(CachedNews.self).filter("title == %@", post.title!).first
        try! realm.write {
            article!.saved = !post.saved
        }
        tableView.reloadData()
    }
    
    func onSaveSuccessed() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        
        if let url = articles?[indexPath.row].urlToImage {
            cell.newsImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder"))
        }
        cell.newsTitleLbl.text = articles?[indexPath.row].title
        cell.newsDateLbl.text = decodeDate(date: (articles![indexPath.row].publishedAt)!)
        cell.newsSavedButton.setImage(UIImage(named: (articles?[indexPath.row].saved)! ? "SavedIcons.png" : "Empty.png"), for: .normal)
        cell.cellDelegate = self
        cell.post = articles?[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchButton" {return}
        if segue.identifier == "aboutSegue" {return}
        if segue.identifier == "savedSegue" {
            let dVC = segue.destination as! SavedTableViewController
            dVC.delegate = self
            return
        }
        guard let index = tableView.indexPathForSelectedRow?.row else {fatalError("can't get index of selected cell.")}
        let destinationVC = segue.destination as! NewsDetailViewController
        destinationVC.article = articles?[index]
    }

    @IBAction func sideBarMenu(_ sender: Any) {
        present(sideBarMenu!, animated: true)
    }
    
    @objc func receiveNotification(notification: Notification) {
        newsProvider.fetchArticles()
    }
}
