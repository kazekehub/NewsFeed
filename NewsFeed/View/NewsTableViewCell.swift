//
//  NewsTableViewCell.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 6/29/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit

protocol TableCellDelegate {
    func saveButtonClicked(post: CachedNews)
}

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardNewsView: UIView!
    @IBOutlet weak var newsTitleLbl: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsSavedButton: UIButton!
    @IBOutlet weak var newsDateLbl: UILabel!
    
    var cellDelegate: TableCellDelegate?
    var post: CachedNews!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardNewsView.layer.cornerRadius = 20
        cardNewsView.layer.shadowColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1).cgColor
        cardNewsView.layer.shadowOpacity = 50
        cardNewsView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        cardNewsView.layer.shadowRadius = 10
    }

    @IBAction func savedButtonClicked(_ sender: Any) {
        cellDelegate?.saveButtonClicked(post: post!)
    }
}
