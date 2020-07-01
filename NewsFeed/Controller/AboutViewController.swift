//
//  AboutViewController.swift
//  NewsFeed
//
//  Created by Beka Zhapparkulov on 7/1/20.
//  Copyright © 2020 Kazybek. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = profileImage.roundImageView(imageView: profileImage)
    }
    
    @IBAction func emailButton(_ sender: Any) {
        
    }
    
    @IBAction func linkedInButton(_ sender: Any) {
        
    }
    
    
    func messageSend(email: String) {
        if MFMailComposeViewController.canSendMail() {
        let mymail = MFMailComposeViewController()
        mymail.mailComposeDelegate = self
        mymail.setToRecipients([email])
        present(mymail, animated: true)
        } else {
            print("Can not send email")
        }
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}
