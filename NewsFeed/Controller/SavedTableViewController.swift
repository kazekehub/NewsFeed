//
//  SavedTableViewController.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 6/29/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder
import RealmSwift

protocol SavedControllerDelegate: class {
    func onSaveSuccessed()
}

class SavedTableViewController: UITableViewController, NewsTableCellDelegate {
    
    weak var delegate: SavedControllerDelegate?
    let realm = try! Realm()
    var articles: [CachedNews]?
    var hasAlreadyLaunched: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articles = Array(realm.objects(CachedNews.self).filter("saved == true").sorted(byKeyPath: "publishedAt", ascending: false))
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        hasAlreadyLaunched = UserDefaults.standard.bool(forKey: "hasAlreadyLaunched")
        if !hasAlreadyLaunched {
            UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
        }
        navigationController?.navigationBar.barStyle = .black
    }

    func newsSaveButtonClick(post: CachedNews) {
        let realm = try! Realm()
        let article = realm.objects(CachedNews.self).filter("title == %@", post.title!).first
        try! realm.write {
            article!.saved = !post.saved
        }
        updateUI()
        delegate?.onSaveSuccessed()
    }
    
    func updateUI() {
        articles = Array(realm.objects(CachedNews.self).filter("saved == true").sorted(byKeyPath: "publishedAt", ascending: false))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellSaved", for: indexPath) as! NewsSavedTableViewCell
        
        if let url = articles?[indexPath.row].urlToImage {
            cell.newsSavedImage.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder"))
        }
        cell.newsSavedTitleLbl.text = articles?[indexPath.row].title
        cell.newsSavedDateLbl.text = decodeDate(date: (articles![indexPath.row].publishedAt)!)
        cell.newsSavedButton.setImage(UIImage(named: (articles?[indexPath.row].saved)! ? "SavedIcons.png" : "Empty.png"), for: .normal)
        cell.cellDelegate = self
        cell.post = articles?[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index = tableView.indexPathForSelectedRow?.row else {fatalError("can't get index of selected cell.")}
        let destinationVC = segue.destination as! NewsDetailViewController
        destinationVC.article = articles?[index]
    }
}
