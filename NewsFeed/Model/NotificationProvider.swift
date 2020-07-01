//
//  NotificationProvider.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 6/29/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import Foundation

let notificationSendArticles = Notification.Name("notification_articles")

class NotificationProvider {
    private var timer: Timer?
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (timer) in
            NotificationCenter.default.post(name: notificationSendArticles, object: nil)
        })
    }
    
    func stop() {
        timer?.invalidate()
    }
}
