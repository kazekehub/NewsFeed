//
//  SearchTableViewCell.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 6/29/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchCardView: UIView!
    @IBOutlet weak var searchTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchCardView.layer.cornerRadius = 20
        searchCardView.layer.shadowColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1).cgColor
        searchCardView.layer.shadowOpacity = 50
        searchCardView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        searchCardView.layer.shadowRadius = 10
    }
}
