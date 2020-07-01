//
//  NewsDetailViewController.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 6/29/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit
import SwiftSoup
import SDWebImage
import SDWebImageSVGCoder
import JGProgressHUD
import RealmSwift

class NewsDetailViewController: UIViewController {

    var article: CachedNews?
    let hud = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var sourceLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = article?.categoryName?.capitalizingFirstLetter()
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        DispatchQueue.main.async {
            self.parseHTML()
            self.hud.dismiss()
        }
        let urlImage = self.article?.urlToImage
        newsImageView.sd_setImage(with: URL(string: urlImage ?? ""), placeholderImage: UIImage(named: "placeholder"))
        authorLbl.text = article?.author
        sourceLbl.text = article?.sourceName
        newsTitleLbl.text = article?.title
       }
    
    func parseHTML() {
        guard let urlString = article?.url else {fatalError("Cannot get url string.")}
        guard let url = URL(string: urlString) else {fatalError("Cannot get url.")}
        do {
            let htmlString = try String(contentsOf: url)
            let html = try SwiftSoup.parse(htmlString)
            let p = try html.getElementsByTag("p").text()
            contentTextView.text = p
        } catch {
            fatalError("error parsing html.")
        }
        let realm = try! Realm()
        let post = realm.objects(CachedNews.self).filter("title == %@", article!.title!).first
        try! realm.write {
            post!.content = contentTextView.text
        }
    }
    
    @IBAction func visitNewsOriginalSourceButton(_ sender: Any) {
        guard let url = URL(string: (article?.url)!) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let urlString = article?.url
        let postTitle = article?.title
        let items: [Any] = [postTitle!, URL(string: urlString!)!]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityController, animated: true)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
