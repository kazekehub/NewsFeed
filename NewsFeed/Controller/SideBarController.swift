//
//  SideBarController.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 6/29/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit
import SideMenu

protocol SideBarDelegate {
    func reload(category: String, navigationBarTitle: String)
    func runSegue(identifier: String)
}

class SideBarController: UITableViewController {
    
    struct Objects {
        var sectionName: String
        var sectionObjects: [(String?, String?, String?)]
    }
    
    var objectsArray =
        [Objects(sectionName: "Categories",
                 sectionObjects: [("Popular", "top-headlines?sources=the-next-web", "popular"),
                                ("World", "everything?q=world", "world"),
                                ("Business", "everything?q=business", "business"),
                                ("Politics", "everything?q=politics", "politics"),
                                ("Health", "everything?q=health", "health"),
                                ("COVID-19", "everything?q=coronavirus", "covid19"),
                                ("Tech", "everything?q=tech", "tech"),
                                ("Travel", "everything?q=travel", "travel"),
                                ("Sports", "everything?q=sports", "sports"),
                                ("Arts", "everything?q=arts", "arts"),
                                ("Music", "everything?q=music", "music")]),
        Objects(sectionName: "Pages",
                sectionObjects: [("Saved News", nil, "book-mark"),
                                ("About", nil, "info-circle")])]
    
    var delegate: SideBarDelegate?
    let urlSkeleton = "https://newsapi.org/v2/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.259, green: 0.404, blue: 0.698, alpha: 1)
        navigationItem.title = "News Feed"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArray[section].sectionObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = objectsArray[indexPath.section].sectionObjects[indexPath.row].0
        cell.imageView?.image = UIImage(named: objectsArray[indexPath.section].sectionObjects[indexPath.row].2!)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return objectsArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsArray[section].sectionName
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)
        if objectsArray[indexPath.section].sectionName == "Categories" {
            delegate?.reload(category: objectsArray[indexPath.section].sectionObjects[indexPath.row].1!, navigationBarTitle: objectsArray[indexPath.section].sectionObjects[indexPath.row].0!)
        } else {
            if objectsArray[indexPath.section].sectionObjects[indexPath.row].0 == "Saved News" {
                delegate?.runSegue(identifier: "savedSegue")
            } else {
                delegate?.runSegue(identifier: "aboutSegue")
            }
        }
    }
}
