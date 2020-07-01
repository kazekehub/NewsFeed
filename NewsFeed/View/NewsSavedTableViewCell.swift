//
//  NewsSavedTableViewCell.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 6/29/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit

protocol NewsTableCellDelegate {
    func newsSaveButtonClick(post: CachedNews)
}

class NewsSavedTableViewCell: UITableViewCell {

    @IBOutlet weak var cardSavedNewsView: UIView!
    @IBOutlet weak var newsSavedImage: UIImageView!
    @IBOutlet weak var newsSavedTitleLbl: UILabel!
    @IBOutlet weak var newsSavedDateLbl: UILabel!
    @IBOutlet weak var newsSavedButton: UIButton!
    
    var cellDelegate: NewsTableCellDelegate?
    var post: CachedNews!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardSavedNewsView.layer.cornerRadius = 20
        cardSavedNewsView.layer.shadowColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1).cgColor
        cardSavedNewsView.layer.shadowOpacity = 50
        cardSavedNewsView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        cardSavedNewsView.layer.shadowRadius = 10
    }
    
    @IBAction func newsSaveButtonClick(_ sender: Any) {
        cellDelegate?.newsSaveButtonClick(post: post!)
    }
}
