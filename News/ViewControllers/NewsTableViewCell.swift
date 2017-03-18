//
//  NewsTableViewCell.swift
//  News
//
//  Created by Mahmoud Ben Messaoud on 17/03/2017.
//  Copyright © 2017 Mahmoud Ben Messaoud. All rights reserved.
//

import UIKit
import Kingfisher

class NewsTableViewCell: UITableViewCell {
    var news : Item!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsPhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with news: Item) {
        self.news = news
        titleLabel.text = news.title
        newsPhoto.kf.indicatorType = .activity
        newsPhoto.kf.setImage(with: news, placeholder: #imageLiteral(resourceName: "loadingImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }

}

extension Item: Resource {
    var cacheKey: String{
        return self.title
    }

    var downloadURL: URL{
        return URL(string: self.image)!
    }
}
