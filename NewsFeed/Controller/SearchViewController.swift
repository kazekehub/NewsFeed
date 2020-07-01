//
//  SearchViewController.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 6/29/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet weak var searchImageBackground: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var recentSearchLbl: UILabel!
    
    var isTextFieldClicked = false
    var articles: [CachedNews]?
    var recentSearch: [String] = []
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.tableFooterView = UIView()
        recentSearch = userDefaults.stringArray(forKey: "keyTitle") ?? [String]()
    }

    @IBAction func clearButtonClick(_ sender: Any) {
        userDefaults.removeObject(forKey: "keyTitle")
        recentSearch.removeAll()
        searchTableView.reloadData()
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        isTextFieldClicked = false
        searchTextField.text = ""
        searchImageBackground.alpha = 1.0
        recentSearchLbl.alpha = 1.0
        clearButton.alpha = 1.0
        searchTableView.reloadData()
    }
    
    @IBAction func searchTextFieldClick(_ sender: Any) {
        isTextFieldClicked = true
        let realm = try! Realm()
        let searchingString = "*"+(searchTextField?.text ?? "")+"*"
        articles = Array(realm.objects(CachedNews.self).filter("title like [c]%@ or content like [c]%@", searchingString, searchingString))
        searchImageBackground.alpha = 0.0
        recentSearchLbl.alpha = 0.0
        clearButton.alpha = 0.0
        searchTableView.alpha = 1.0
        searchTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isTextFieldClicked {
            return articles?.count ?? 0
        } else {
            return recentSearch.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTableViewCell
        cell.selectionStyle = .none
        if isTextFieldClicked {
            cell.searchTitleLbl?.text = articles?[indexPath.row].title
        } else {
            cell.searchTitleLbl?.text = recentSearch[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isTextFieldClicked {
            performSegue(withIdentifier: "goToDetail", sender: self)
            recentSearch.append(searchTextField.text!)
            userDefaults.set(recentSearch, forKey: "keyTitle")
        } else {
            searchTextField.text = recentSearch[indexPath.row]
            searchTextFieldClick(self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            guard let index = searchTableView.indexPathForSelectedRow?.row
                else {fatalError("can't get index of selected cell.")}
            let destinationVC = segue.destination as! NewsDetailViewController
            destinationVC.article = articles?[index]
        }
    }
}
