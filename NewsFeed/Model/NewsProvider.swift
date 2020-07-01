//
//  NewsProvider.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 6/29/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import Foundation
import RealmSwift

protocol NewsProviderDelegate {
    func updateUI(with category: String)
}

class NewsProvider {

    var delegate: NewsProviderDelegate?
    var selectedCategory = "top-headlines?sources=the-next-web"
    let apiKey = "apiKey=a46f989eadb3458493488519f1bc566e"
    
    func fetchArticles(baseURL: String = "https://newsapi.org/v2/") {
        guard let url = URL(string: "\(baseURL)\(selectedCategory)&\(apiKey)") else {print("Fail instance of url.");return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            } else {
                if let safeData = data {
                    do {
                        let decodedData = try JSONDecoder().decode(PieceOfNews.self, from: safeData)
                        let articles = decodedData.articles
                        let databaseCategory = self.selectedCategory.replacingOccurrences(of: "everything?q=", with: "")
                        if databaseCategory.contains("?") {
                            self.saveArticles(articles: articles)
                        } else {
                            self.saveArticles(articles: articles, to: databaseCategory)
                        }
                    } catch {
                        print("Error decoding data: \(error.localizedDescription)")
                    }
                }
            }
        }
        task.resume()
    }
    
    func saveArticles(articles: [Article], to category: String = "popular") {
        DispatchQueue.main.async {
            let realm = try! Realm()
            
            try! realm.write {
                for article in articles {
                    var url = article.url
                    url = url.replacingOccurrences(of: "http://", with: "https://")
                    var urlToImage = article.urlToImage
                    urlToImage = urlToImage?.replacingOccurrences(of: "http://", with: "https://")
                    let arrayValues = ["author": article.author, "publishedAt": article.publishedAt, "title": article.title, "url": url, "urlToImage": urlToImage, "sourceName": article.source.name, "categoryName": category]
                    realm.create(CachedNews.self, value: arrayValues, update: .modified)
                }
            }
            self.delegate?.updateUI(with: category)
        }
    }
}
