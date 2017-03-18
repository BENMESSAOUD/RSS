//
//  DetailNewsViewController.swift
//  News
//
//  Created by Mahmoud Ben Messaoud on 18/03/2017.
//  Copyright © 2017 Mahmoud Ben Messaoud. All rights reserved.
//

import UIKit
import Kingfisher
class DetailNewsViewController: UIViewController {
    var news: Item?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var newsPhoto: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var siteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = news?.title ?? kEmptyString
        if let newsDate = news?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
            self.dateLabel.text = dateFormatter.string(from: newsDate)
        }
        else{
            self.dateLabel.text = kEmptyString
        }
        newsPhoto.kf.indicatorType = .activity
        newsPhoto.kf.setImage(with: news, placeholder: #imageLiteral(resourceName: "loadingImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
        descriptionText.text = news?.description ?? kEmptyString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToSite(_ sender: Any) {
        guard let link = news?.link, let url = URL(string: link)  else {
            return
        }
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, completionHandler: nil)
        }
    }

}
