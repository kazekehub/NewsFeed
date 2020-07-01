//
//  Extensions.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 6/29/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit
import MessageUI

extension UIImageView {
    func roundImageView(imageView: UIImageView) -> UIImageView {
        imageView.layer.borderWidth = 0.5
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        return imageView
    }
}
func decodeDate(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let normalDate = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "HH:mm:ss dd.MM.yyyy"
    dateFormatter.timeZone = TimeZone.current
    return "\(dateFormatter.string(from: normalDate!))"
}
